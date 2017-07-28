# 
# https://docs.openstack.org/ocata/install-guide-rdo/glance-install.html
#

{% from "openstack/mysql/map.jinja" import mysql with context %}

{% set glance_dbpass = salt['pillar.get']('openstack:auth:GLANCE_DBPASS') %}
{% set glance_pass = salt['pillar.get']('openstack:auth:GLANCE_PASS') %}

{% set mysql_host = salt['pillar.get']('openstack:controller:host') %}
{% set controller = salt['pillar.get']('openstack:controller:host') %}

create-glance-user:
  cmd.run:
    - name: openstack user create --password {{ salt['pillar.get']('openstack:auth:GLANCE_PASS') }} glance
    - env: {{ salt['pillar.get']('openstack:env', {}) }}
    - unless:
      - openstack user show glance

# Add the admin role to the glance user and service project:
add-admin-role-to-glance:
  cmd.run:
    - name: 'openstack role add --project service --user glance admin'
    - env: {{ salt['pillar.get']('openstack:env', {}) }}

# Create glance service entry
create-glance-service:
  cmd.run:
    - name: 'openstack service create --name glance --description "OpenStack Image service" image'
    - env: {{ salt['pillar.get']('openstack:env', {}) }}
    - unless:
      - openstack service show image


# Create glance service API endpoints
glance-public-service-endpoint:
  cmd.run:
    - name: 'openstack endpoint create --region RegionOne image public http://{{ controller }}:9292'
    - env: {{ salt['pillar.get']('openstack:env', {}) }}
#    - unless:
#      - openstack endpoint list --service image --interface public

glance-internal-service-endpoint:
  cmd.run:
    - name: 'openstack endpoint create --region RegionOne image internal http://{{ controller }}:9292'
    - env: {{ salt['pillar.get']('openstack:env', {}) }}
#    - unless:
#      - openstack endpoint list --service image --interface internal

glance-admin-service-endpoint:
  cmd.run:
    - name: 'openstack endpoint create --region RegionOne image admin http://{{ controller }}:9292'
    - env: {{ salt['pillar.get']('openstack:env', {}) }}
#    - unless:
#      - openstack endpoint list --service image --interface admin

#
#
# Install and configure components
#

# 1. install the packages
glance-pkgs:
  pkg.installed:
    - pkgs:
      - openstack-glance

# 2. Edit the /etc/glance/glance-api.conf file and complete the following actions:
/etc/glance/glance-api.conf:
  ini.options_present:
    - sections:
        database:
          connection: 'mysql+pymysql://glance:{{ glance_dbpass }}@{{ mysql_host }}/glance'
        keystone_authtoken:
          auth_uri: http://{{ controller }}:5000
          auth_url: http://{{ controller }}:35357
          memcached_servers: {{ controller }}:11211
          auth_type: password
          project_domain_name: default
          user_domain_name: default
          project_name: service
          username: glance
          password: {{ glance_pass }}
        paste_deploy:
          flavor: keystone
        glance_store:
          stores: file,http
          default_store: file
          filesystem_store_datadir: /var/lib/glance/images/

# 3. 
/etc/glance/glance-registry.conf:
  ini.options_present:
    - sections:
        database:
          connection: 'mysql+pymysql://glance:{{ glance_dbpass }}@{{ mysql_host }}/glance'
        keystone_authtoken:
          auth_uri: http://{{ controller }}:5000
          auth_url: http://{{ controller }}:35357
          memcached_servers: {{ controller }}:11211
          auth_type: password
          project_domain_name: default
          user_domain_name: default
          project_name: service
          username: glance
          password: {{ glance_pass }}
        paste_deploy:
          flavor: keystone

# 4. Populate the Image service database:
glance_db_sync:
  cmd.run:
    - name: glance-manage db_sync
    - user: glance
    - shell: /bin/sh

#
# Finalize Installationb
# 

glance-api-service:
  service.running:
    - name: openstack-glance-api
    - enable: True
    - watch:
      - ini: /etc/glance/glance-api.conf

glance-registry-service:
  service.running:
    - name: openstack-glance-registry
    - enable: True
    - watch:
      - ini: /etc/glance/glance-registry.conf

glance.sh:
  file.managed:
    - name: {{ salt['pillar.get']('openstack:tools_dir') }}/glance.sh
    - source: salt://openstack/glance/files/glance.sh

