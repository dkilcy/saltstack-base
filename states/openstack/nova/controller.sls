# 
# https://docs.openstack.org/ocata/install-guide-rdo/nova-controller-install.html
#

{% from "mysql/map.jinja" import mysql with context %}

{% set nova_dbpass = salt['pillar.get']('openstack:auth:NOVA_DBPASS') %}
{% set nova_pass = salt['pillar.get']('openstack:auth:NOVA_PASS') %}
{% set rabbit_pass = salt['pillar.get']('openstack:auth:RABBIT_PASS') %}
{% set placement_pass = salt['pillar.get']('openstack:auth:PLACEMENT_PASS') %}

{% set mysql_host = salt['pillar.get']('openstack:controller:host') %}
{% set controller = salt['pillar.get']('openstack:controller:host') %}


create-nova-user:
  cmd.run:
    - name: openstack user create --password {{ salt['pillar.get']('openstack:auth:NOVA_PASS') }} nova
    - env: {{ salt['pillar.get']('openstack:env', {}) }}
    - unless:
      - openstack user show nova

add-admin-role-to-nova:
  cmd.run:
    - name: openstack role add --project service --user nova admin
    - env: {{ salt['pillar.get']('openstack:env', {}) }}

create-nova-service:
  cmd.run:
    - name: openstack service create --name nova --description "OpenStack Compute service" compute
    - env: {{ salt['pillar.get']('openstack:env', {}) }}
    - unless:
      - openstack service show compute

nova-public-service-endpoint:
  cmd.run:
    - name: 'openstack endpoint create --region RegionOne compute public http://{{ controller }}:8774/v2.1'
    - env: {{ salt['pillar.get']('openstack:env', {}) }}

nova-internal-service-endpoint:
  cmd.run:
    - name: 'openstack endpoint create --region RegionOne compute internal http://{{ controller }}:8774/v2.1'
    - env: {{ salt['pillar.get']('openstack:env', {}) }}

nova-admin-service-endpoint:
  cmd.run:
    - name: 'openstack endpoint create --region RegionOne compute admin http://{{ controller }}:8774/v2.1'
    - env: {{ salt['pillar.get']('openstack:env', {}) }}

# Placement
create-placement-user:
  cmd.run:
    - name: openstack user create --domain default --password {{ salt['pillar.get']('openstack:auth:PLACEMENT_PASS') }} placement
    - env: {{ salt['pillar.get']('openstack:env', {}) }}
    - unless:
      - openstack user show placement

add-admin-role-to-placement:
  cmd.run:
    - name: openstack role add --project service --user placement admin
    - env: {{ salt['pillar.get']('openstack:env', {}) }}

create-placement-service:
  cmd.run:
    - name: openstack service create --name placement --description "Placement API" placement
    - env: {{ salt['pillar.get']('openstack:env', {}) }}
    - unless:
      - openstack service show placement

placement-public-service-endpoint:
  cmd.run:
    - name: 'openstack endpoint create --region RegionOne placement public http://{{ controller }}:8778'
    - env: {{ salt['pillar.get']('openstack:env', {}) }}

placement-internal-service-endpoint:
  cmd.run:
    - name: 'openstack endpoint create --region RegionOne placement internal http://{{ controller }}:8778'
    - env: {{ salt['pillar.get']('openstack:env', {}) }}

placement-admin-service-endpoint:
  cmd.run:
    - name: 'openstack endpoint create --region RegionOne placement admin http://{{ controller }}:8778'
    - env: {{ salt['pillar.get']('openstack:env', {}) }}

#
# Install and configure components
#

# 1. install the packages
nova-pkgs:
  pkg.installed:
    - pkgs:
      - openstack-nova-api
      - openstack-nova-conductor
      - openstack-nova-console
      - openstack-nova-novncproxy
      - openstack-nova-scheduler
      - openstack-nova-placement-api

# This needs to go here for placement API endpoints to be created successfully ??
# packaging bug...
/etc/httpd/conf.d/00-nova-placement-api.conf:
  file.append:
    - name: /etc/httpd/conf.d/00-nova-placement-api.conf
    - text: |
        <Directory /usr/bin>
           <IfVersion >= 2.4>
              Require all granted
           </IfVersion>
           <IfVersion < 2.4>
              Order allow,deny
              Allow from all
           </IfVersion>
        </Directory>
  service.running:
    - name: httpd
    - watch:
      - file: /etc/httpd/conf.d/00-nova-placement-api.conf

# 2. Edit the /etc/nova/nova-api.conf file and complete the following actions:
/etc/nova/nova.conf:
  ini.options_present:
    - sections:
        DEFAULT:
          enabled_apis: osapi_compute,metadata
          transport_url: 'rabbit://openstack:{{ rabbit_pass }}@controller'
          my_ip: {{ salt['grains.get']('fqdn_ip4:0') }}
          use_neutron: True
          firewall_driver: nova.virt.firewall.NoopFirewallDriver
        database:
          connection: 'mysql+pymysql://nova:{{ nova_dbpass }}@{{ mysql_host }}/nova'
        api_database:
          connection: 'mysql+pymysql://nova:{{ nova_dbpass }}@{{ mysql_host }}/nova_api'
        keystone_authtoken:
          auth_uri: 'http://{{ controller }}:5000'
          auth_url: 'http://{{ controller }}:35357'
          memcached_servers: '{{ controller }}:11211'
          auth_type: password
          project_domain_name: default
          user_domain_name: default
          project_name: service
          username: nova
          password: {{ nova_pass }}
        vnc:
          enabled: true
          vncserver_listen: $my_ip
          vncserver_proxyclient_address: $my_ip
        glance:
          api_servers: 'http://{{ controller }}:9292'
        oslo_concurrency:
          lock_path: /var/lib/nova/tmp
        placement:
          os_region_name: RegionOne
          project_domain_name: default
          project_name: service
          auth_type: password
          user_domain_name: default
          auth_url: 'http://{{ controller }}:35357/v3'
          username: placement
          password: {{ placement_pass }}
        scheduler:
          discover_hosts_in_cells_interval: 300

populate_nova_api_database:
  cmd.run:
    - name: nova-manage api_db sync
    - user: nova
    - shell: /bin/sh

register_cell0_db:
  cmd.run:
    - name: nova-manage cell_v2 map_cell0
    - user: nova
    - shell: /bin/sh

create_cell1_cell:
  cmd.run:
    - name: nova-manage cell_v2 create_cell --name=cell1 --verbose
    - user: nova
    - shell: /bin/sh

populate_nova_database:
  cmd.run:
    - name: nova-manage db sync
    - user: nova
    - shell: /bin/sh


openstack-nova-api.service:
  service.running:
    - enable: True
    - watch:
      - ini: /etc/nova/nova.conf

openstack-nova-consoleauth.service:
  service.running:
    - enable: True
    - watch:
      - ini: /etc/nova/nova.conf

openstack-nova-scheduler.service:
  service.running:
    - enable: True
    - watch:
      - ini: /etc/nova/nova.conf

openstack-nova-conductor.service:
  service.running:
    - enable: True
    - watch:
      - ini: /etc/nova/nova.conf

openstack-nova-novncproxy.service:
  service.running:
    - enable: True
    - watch:
      - ini: /etc/nova/nova.conf

