# 
# https://docs.openstack.org/ocata/install-guide-rdo/glance-install.html
#

{% from "mysql/map.jinja" import mysql with context %}

{% set glance_dbpass = salt['pillar.get']('openstack:auth:GLANCE_DBPASS') %}
{% set glance_pass = salt['pillar.get']('openstack:auth:GLANCE_PASS') %}

{% set mysql_host = salt['pillar.get']('openstack:controller:host') %}
{% set mysql_root_password = salt['pillar.get']('mysql:root_pass') %}
{% set controller = salt['pillar.get']('openstack:controller:host') %}

#
# Create the glance database
#

{{ mysql.service }}-glance:
  service.running:
    - name: {{ mysql.service }}

glance_db:
  mysql_database.present:
    - name: glance
    - host: {{ mysql_host }}
    - connection_user: root
    - connection_pass: '{{ mysql_root_password }}'
    - connection_charset: utf8
    - require:
      - service: {{ mysql.service }}-glance
#      - pkg: {{ mysql.python }}

# 
# Grant proper access to the glance database:
#

glance_grant_localhost:
  mysql_user.present:
    - name: glance
    - host: localhost
    - password: {{ glance_dbpass }}
    - connection_user: root
    - connection_pass: '{{ mysql_root_password }}'
    - connection_charset: utf8
    - require:
      - service: {{ mysql.service }}-glance
#      - pkg: {{ mysql.python }}

  mysql_grants.present:
    - grant: all privileges
    - database: glance.*
    - user: glance
    - host: localhost
    - connection_user: root
    - connection_pass: '{{ mysql_root_password }}'
    - connection_charset: utf8
    - require:
      - service: {{ mysql.service }}-glance
#      - pkg: {{ mysql.python }}

glance_grant_all:
  mysql_user.present:
    - name: glance
    - host: '%'
    - password: {{ glance_dbpass }}
    - connection_user: root
    - connection_pass: '{{ mysql_root_password }}'
    - connection_charset: utf8
    - require:
      - service: {{ mysql.service }}-glance
#      - pkg: {{ mysql.python }}

  mysql_grants.present:
    - grant: all privileges
    - database: glance.*
    - user: glance
    - host: '%'
    - connection_user: root
    - connection_pass: '{{ mysql_root_password }}'
    - connection_charset: utf8
    - require:
      - service: {{ mysql.service }}-glance
#      - pkg: {{ mysql.python }}


glance_grant_controller:
  mysql_user.present:
    - name: glance
    - host: '{{ salt['grains.get']('nodename') }}'
    - password: {{ glance_dbpass }}
    - connection_user: root
    - connection_pass: '{{ mysql_root_password }}'
    - connection_charset: utf8
    - require:
      - service: {{ mysql.service }}-glance
#      - pkg: {{ mysql.python }}

  mysql_grants.present:
    - grant: all privileges
    - database: glance.*
    - user: glance
    - host: '{{ salt['grains.get']('nodename') }}'
    - connection_user: root
    - connection_pass: '{{ mysql_root_password }}'
    - connection_charset: utf8
    - require:
      - service: {{ mysql.service }}-glance
#      - pkg: {{ mysql.python }}

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
#    - watch:
#      - file: /etc/glance/glance-api.conf

glance-registry-service:
  service.running:
    - name: openstack-glance-registry
    - enable: True
#    - watch:
#      - file: /etc/glance/glance-registry.conf

