# 
# https://docs.openstack.org/ocata/install-guide-rdo/keystone-install.html
#

{% from "mysql/map.jinja" import mysql with context %}

{% set mysql_host = salt['pillar.get']('openstack:controller:host') %}
{% set controller = salt['pillar.get']('openstack:controller:host') %}

{% set keystone_dbpass = salt['pillar.get']('openstack:auth:KEYSTONE_DBPASS') %}

#
# Install and configure components
#

# 1. install the packages
keystone-pkgs:
  pkg.installed:
    - pkgs:
      - openstack-keystone
      - httpd
      - mod_wsgi

# 2. Edit the /etc/keystone/keystone.conf file and complete the following actions:
/etc/keystone/keystone.conf:
  ini.options_present:
    - sections:
        database:
          connection: 'mysql+pymysql://keystone:{{ keystone_dbpass }}@{{ mysql_host }}/keystone'
        token:
          provider: fernet


# 3. Populate the Identity service database:
keystone_db_sync:
  cmd.run:
    - name: keystone-manage db_sync
    - user: keystone
    - shell: /bin/sh

# 4. Initialize Fernet key repositories
fernet_setup:
  cmd.run:
    - name: 'keystone-manage fernet_setup --keystone-user keystone --keystone-group keystone'
credential_setup:
  cmd.run:
    - name: 'keystone-manage credential_setup --keystone-user keystone --keystone-group keystone'

# 5. Bootstrap the Identity service
keystone-bootstrap:
  cmd.run:
    - name: 'keystone-manage bootstrap --bootstrap-password {{ salt['pillar.get']('openstack:auth:ADMIN_PASS') }}  --bootstrap-admin-url http://{{ controller }}:35357/v3/  --bootstrap-internal-url http://{{ controller }}:5000/v3/  --bootstrap-public-url http://{{ controller }}:5000/v3/  --bootstrap-region-id RegionOne'

#
# Configure Apache HTTP server
#

/etc/httpd/conf/httpd.conf:
  file.replace:
    - name: /etc/httpd/conf/httpd.conf
    - pattern: '#ServerName www.example.com:80'
    - repl: 'ServerName {{ controller }}'

/etc/httpd/conf.d/wsgi-keystone.conf:
  file.symlink:
    - name: /etc/httpd/conf.d/wsgi-keystone.conf
    - target: /usr/share/keystone/wsgi-keystone.conf

httpd-service:
  service.running:
    - name: httpd
    - enable: True
    - watch:
      - file: /etc/httpd/conf/httpd.conf
      - file: /etc/httpd/conf.d/wsgi-keystone.conf

create-service-project:
  cmd.run:
    - name: openstack project create --domain default --description "Service Project" service 
    - env: {{ salt['pillar.get']('openstack:env', {}) }}
    - unless:
      - openstack project show service

create-demo-project:
  cmd.run:
    - name: openstack project create --domain default --description "Demo Project" demo
    - env: {{ salt['pillar.get']('openstack:env', {}) }}
    - unless:
      - openstack project show demo

create-demo-user:
  cmd.run:
    - name: openstack user create --domain default --password {{ salt['pillar.get']('openstack:auth:DEMO_PASS') }} demo
    - env: {{ salt['pillar.get']('openstack:env', {}) }}
    - unless:
      - openstack user show demo

create-demo-user-role:
  cmd.run:
    - name: openstack role create user
    - env: {{ salt['pillar.get']('openstack:env', {}) }}
    - unless:
      - openstack role show user

add-user-role-to-demo:
  cmd.run:
    - name: openstack role add --project demo --user demo user
    - env: {{ salt['pillar.get']('openstack:env', {}) }}

keystone.sh:
  file.managed:
    - name: {{ salt['pillar.get']('openstack:tools_dir') }}/keystone.sh
    - source: salt://openstack/keystone/files/keystone.sh

