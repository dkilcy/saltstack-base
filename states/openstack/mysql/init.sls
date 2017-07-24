{% from "mysql/map.jinja" import mysql with context %}

{% set mysql_host = salt['pillar.get']('openstack:controller:host') %}
{% set mysql_root_password = salt['pillar.get']('mysql:root_pass') %}
{% set controller = salt['pillar.get']('openstack:controller:host') %}

{% set keystone_dbpass = salt['pillar.get']('openstack:auth:KEYSTONE_DBPASS') %}
{% set glance_dbpass = salt['pillar.get']('openstack:auth:GLANCE_DBPASS') %}
{% set nova_dbpass = salt['pillar.get']('openstack:auth:NOVA_DBPASS') %}
{% set neutron_dbpass = salt['pillar.get']('openstack:auth:NEUTRON_DBPASS') %}



mysql-server:

  pkg.installed:
    - pkgs:
      - {{ mysql.client }}
      - {{ mysql.server }}
      - {{ mysql.python }}

  file.managed:
    - name: {{ mysql.config }}
    - mode: 644
    - user: root
    - group: root
#    - require:
#      - pkg: {{ mysql.server }}
    - contents: |
        [mysqld]
        bind-address = 0.0.0.0
        default-storage-engine = innodb
        innodb_file_per_table = on
        max_connections = 4096
        collation-server = utf8_general_ci
        character-set-server = utf8

  service.running:
    - name: {{ mysql.service }}
    - enable: True
#    - require:
#      - pkg: {{ mysql.server }}

  mysql_user.present:
    - name: root
    - host: localhost
    - password: {{ salt['pillar.get']('mysql:root_pass') }}
    - password_hash: '*'
    - require:
      - service: {{ mysql.service }}

#
# Identity Service
#

keystone_db:
  mysql_database.present:
    - name: keystone
    - host: {{ mysql_host }}
    - connection_user: root
    - connection_pass: '{{ mysql_root_password }}'
    - connection_charset: utf8
    - require:
      - service: {{ mysql.service }}

keystone_grant_localhost:
  mysql_user.present:
    - name: keystone
    - host: localhost
    - password: {{ keystone_dbpass }}
    - connection_user: root
    - connection_pass: '{{ mysql_root_password }}'
    - connection_charset: utf8
    - require:
      - service: {{ mysql.service }}

  mysql_grants.present:
    - grant: all privileges
    - database: keystone.*
    - user: keystone
    - host: localhost
    - connection_user: root
    - connection_pass: '{{ mysql_root_password }}'
    - connection_charset: utf8
    - require:
      - service: {{ mysql.service }}

keystone_grant_all:
  mysql_user.present:
    - name: keystone
    - host: '%'
    - password: {{ keystone_dbpass }}
    - connection_user: root
    - connection_pass: '{{ mysql_root_password }}'
    - connection_charset: utf8
    - require:
      - service: {{ mysql.service }}

  mysql_grants.present:
    - grant: all privileges
    - database: keystone.*
    - user: keystone
    - host: '%'
    - connection_user: root
    - connection_pass: '{{ mysql_root_password }}'
    - connection_charset: utf8
    - require:
      - service: {{ mysql.service }}

keystone_grant_controller:
  mysql_user.present:
    - name: keystone
    - host: '{{ salt['grains.get']('nodename') }}'
    - password: {{ keystone_dbpass }}
    - connection_user: root
    - connection_pass: '{{ mysql_root_password }}'
    - connection_charset: utf8
    - require:
      - service: {{ mysql.service }}

  mysql_grants.present:
    - grant: all privileges
    - database: keystone.*
    - user: keystone
    - host: '{{ salt['grains.get']('nodename') }}'
    - connection_user: root
    - connection_pass: '{{ mysql_root_password }}'
    - connection_charset: utf8
    - require:
      - service: {{ mysql.service }}

#
# Image Service
#

glance_db:
  mysql_database.present:
    - name: glance
    - host: {{ mysql_host }}
    - connection_user: root
    - connection_pass: '{{ mysql_root_password }}'
    - connection_charset: utf8
    - require:
      - service: {{ mysql.service }}
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
      - service: {{ mysql.service }}

  mysql_grants.present:
    - grant: all privileges
    - database: glance.*
    - user: glance
    - host: localhost
    - connection_user: root
    - connection_pass: '{{ mysql_root_password }}'
    - connection_charset: utf8
    - require:
      - service: {{ mysql.service }}

glance_grant_all:
  mysql_user.present:
    - name: glance
    - host: '%'
    - password: {{ glance_dbpass }}
    - connection_user: root
    - connection_pass: '{{ mysql_root_password }}'
    - connection_charset: utf8
    - require:
      - service: {{ mysql.service }}

  mysql_grants.present:
    - grant: all privileges
    - database: glance.*
    - user: glance
    - host: '%'
    - connection_user: root
    - connection_pass: '{{ mysql_root_password }}'
    - connection_charset: utf8
    - require:
      - service: {{ mysql.service }}

glance_grant_controller:
  mysql_user.present:
    - name: glance
    - host: '{{ salt['grains.get']('nodename') }}'
    - password: {{ glance_dbpass }}
    - connection_user: root
    - connection_pass: '{{ mysql_root_password }}'
    - connection_charset: utf8
    - require:
      - service: {{ mysql.service }}

  mysql_grants.present:
    - grant: all privileges
    - database: glance.*
    - user: glance
    - host: '{{ salt['grains.get']('nodename') }}'
    - connection_user: root
    - connection_pass: '{{ mysql_root_password }}'
    - connection_charset: utf8
    - require:
      - service: {{ mysql.service }}

#
# Nova Controller
#

{% for db in ['nova_api','nova','nova_cell0'] %}

{{ db }}_db:
  mysql_database.present:
    - name: {{ db }}
    - host: {{ mysql_host }}
    - connection_user: root
    - connection_pass: '{{ mysql_root_password }}'
    - connection_charset: utf8
    - require:
      - service: {{ mysql.service }}

# 
# Grant proper access to the nova database:
#

{{ db }}_grant_localhost:
  mysql_user.present:
    - name: nova
    - host: localhost
    - password: {{ nova_dbpass }}
    - connection_user: root
    - connection_pass: '{{ mysql_root_password }}'
    - connection_charset: utf8
    - require:
      - service: {{ mysql.service }}

  mysql_grants.present:
    - grant: all privileges
    - database: {{ db }}.*
    - user: nova
    - host: localhost
    - connection_user: root
    - connection_pass: '{{ mysql_root_password }}'
    - connection_charset: utf8
    - require:
      - service: {{ mysql.service }}

{{ db }}_grant_all:
  mysql_user.present:
    - name: nova
    - host: '%'
    - password: {{ nova_dbpass }}
    - connection_user: root
    - connection_pass: '{{ mysql_root_password }}'
    - connection_charset: utf8
    - require:
      - service: {{ mysql.service }}

  mysql_grants.present:
    - grant: all privileges
    - database: {{ db }}.*
    - user: nova
    - host: '%'
    - connection_user: root
    - connection_pass: '{{ mysql_root_password }}'
    - connection_charset: utf8
    - require:
      - service: {{ mysql.service }}

{{ db }}_grant_controller:
  mysql_user.present:
    - name: nova
    - host: '{{ salt['grains.get']('nodename') }}'
    - password: {{ nova_dbpass }}
    - connection_user: root
    - connection_pass: '{{ mysql_root_password }}'
    - connection_charset: utf8
    - require:
      - service: {{ mysql.service }}

  mysql_grants.present:
    - grant: all privileges
    - database: {{ db }}.*
    - user: nova
    - host: '{{ salt['grains.get']('nodename') }}'
    - connection_user: root
    - connection_pass: '{{ mysql_root_password }}'
    - connection_charset: utf8
    - require:
      - service: {{ mysql.service }}

{% endfor %}

#
# Neutron
#

neutron_db:
  mysql_database.present:
    - name: neutron
    - host: {{ mysql_host }}
    - connection_user: root
    - connection_pass: '{{ mysql_root_password }}'
    - connection_charset: utf8
    - require:
      - service: {{ mysql.service }}

neutron_grant_localhost:
  mysql_user.present:
    - name: neutron
    - host: localhost
    - password: {{ neutron_dbpass }}
    - connection_user: root
    - connection_pass: '{{ mysql_root_password }}'
    - connection_charset: utf8
    - require:
      - service: {{ mysql.service }}

  mysql_grants.present:
    - grant: all privileges
    - database: neutron.*
    - user: neutron
    - host: localhost
    - connection_user: root
    - connection_pass: '{{ mysql_root_password }}'
    - connection_charset: utf8
    - require:
      - service: {{ mysql.service }}

neutron_grant_all:
  mysql_user.present:
    - name: neutron
    - host: '%'
    - password: {{ neutron_dbpass }}
    - connection_user: root
    - connection_pass: '{{ mysql_root_password }}'
    - connection_charset: utf8
    - require:
      - service: {{ mysql.service }}

  mysql_grants.present:
    - grant: all privileges
    - database: neutron.*
    - user: neutron
    - host: '%'
    - connection_user: root
    - connection_pass: '{{ mysql_root_password }}'
    - connection_charset: utf8
    - require:
      - service: {{ mysql.service }}

neutron_grant_controller:
  mysql_user.present:
    - name: neutron
    - host: '{{ salt['grains.get']('nodename') }}'
    - password: {{ neutron_dbpass }}
    - connection_user: root
    - connection_pass: '{{ mysql_root_password }}'
    - connection_charset: utf8
    - require:
      - service: {{ mysql.service }}

  mysql_grants.present:
    - grant: all privileges
    - database: neutron.*
    - user: neutron
    - host: '{{ salt['grains.get']('nodename') }}'
    - connection_user: root
    - connection_pass: '{{ mysql_root_password }}'
    - connection_charset: utf8
    - require:
      - service: {{ mysql.service }}

