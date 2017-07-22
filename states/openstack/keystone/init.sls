# 
# https://docs.openstack.org/ocata/install-guide-rdo/keystone-install.html
#

{% from "mysql/map.jinja" import mysql with context %}

{% set keystone_dbpass = salt['pillar.get']('openstack:auth:KEYSTONE_DBPASS') %}
{% set mysql_host = salt['pillar.get']('openstack:controller:host') %}
{% set mysql_root_password = salt['pillar.get']('mysql:root_pass') %}
{% set controller = salt['pillar.get']('openstack:controller:host') %}

#
# Create the keystone database
#

{{ mysql.service }}-keystone:
  service.running:
    - name: {{ mysql.service }}

keystone_db:
  mysql_database.present:
    - name: keystone
    - host: {{ mysql_host }}
    - connection_user: root
    - connection_pass: '{{ mysql_root_password }}'
    - connection_charset: utf8
    - require:
      - service: {{ mysql.service }}-keystone
#      - pkg: {{ mysql.python }}

# 
# Grant proper access to the keystone database:
#

keystone_grant_localhost:
  mysql_user.present:
    - name: keystone
    - host: localhost
    - password: {{ keystone_dbpass }}
    - connection_user: root
    - connection_pass: '{{ mysql_root_password }}'
    - connection_charset: utf8
    - require:
      - service: {{ mysql.service }}-keystone
#      - pkg: {{ mysql.python }}

  mysql_grants.present:
    - grant: all privileges
    - database: keystone.*
    - user: keystone
    - host: localhost
    - connection_user: root
    - connection_pass: '{{ mysql_root_password }}'
    - connection_charset: utf8
    - require:
      - service: {{ mysql.service }}-keystone
#      - pkg: {{ mysql.python }}

keystone_grant_all:
  mysql_user.present:
    - name: keystone
    - host: '%'
    - password: {{ keystone_dbpass }}
    - connection_user: root
    - connection_pass: '{{ mysql_root_password }}'
    - connection_charset: utf8
    - require:
      - service: {{ mysql.service }}-keystone
#      - pkg: {{ mysql.python }}

  mysql_grants.present:
    - grant: all privileges
    - database: keystone.*
    - user: keystone
    - host: '%'
    - connection_user: root
    - connection_pass: '{{ mysql_root_password }}'
    - connection_charset: utf8
    - require:
      - service: {{ mysql.service }}-keystone
#      - pkg: {{ mysql.python }}


keystone_grant_controller:
  mysql_user.present:
    - name: keystone
    - host: '{{ salt['grains.get']('nodename') }}'
    - password: {{ keystone_dbpass }}
    - connection_user: root
    - connection_pass: '{{ mysql_root_password }}'
    - connection_charset: utf8
    - require:
      - service: {{ mysql.service }}-keystone
#      - pkg: {{ mysql.python }}

  mysql_grants.present:
    - grant: all privileges
    - database: keystone.*
    - user: keystone
    - host: '{{ salt['grains.get']('nodename') }}'
    - connection_user: root
    - connection_pass: '{{ mysql_root_password }}'
    - connection_charset: utf8
    - require:
      - service: {{ mysql.service }}-keystone
#      - pkg: {{ mysql.python }}

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

