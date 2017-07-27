# 
# https://docs.openstack.org/ocata/install-guide-rdo/neutron-controller-install.html
#

{% from "mysql/map.jinja" import mysql with context %}

{% set mysql_host = salt['pillar.get']('openstack:controller:host') %}

{% set neutron_dbpass = salt['pillar.get']('openstack:auth:NEUTRON_DBPASS') %}
{% set neutron_pass = salt['pillar.get']('openstack:auth:NEUTRON_PASS') %}
{% set nova_pass = salt['pillar.get']('openstack:auth:NOVA_PASS') %}
{% set rabbit_pass = salt['pillar.get']('openstack:auth:RABBIT_PASS') %}
{% set metadata_secret = salt['pillar.get']('openstack:auth:METADATA_SECRET') %}
{% set provider_interface_name = salt['pillar.get']('openstack:neutron:controller_provider_interface_name') %}
{% set controller = salt['pillar.get']('openstack:controller:host') %}

create-neutron-user:
  cmd.run:
    - name: openstack user create --domain default --password {{ salt['pillar.get']('openstack:auth:NEUTRON_PASS') }} neutron
    - env: {{ salt['pillar.get']('openstack:env', {}) }}
    - unless:
      - openstack user show neutron

add-admin-role-to-neutron:
  cmd.run:
    - name: openstack role add --project service --user neutron admin
    - env: {{ salt['pillar.get']('openstack:env', {}) }}

create-neutron-service:
  cmd.run:
    - name: openstack service create --name neutron --description "OpenStack Networking service" network
    - env: {{ salt['pillar.get']('openstack:env', {}) }}
    - unless:
      - openstack service show network

neutron-public-service-endpoint:
  cmd.run:
    - name: 'openstack endpoint create --region RegionOne network public http://{{ controller }}:9696'
    - env: {{ salt['pillar.get']('openstack:env', {}) }}
#    - unless:
#      - openstack endpoint list --service network --interface public

neutron-internal-service-endpoint:
  cmd.run:
    - name: 'openstack endpoint create --region RegionOne network internal http://{{ controller }}:9696'
    - env: {{ salt['pillar.get']('openstack:env', {}) }}
#    - unless:
#      - openstack endpoint list --service network --interface internal

neutron-admin-service-endpoint:
  cmd.run:
    - name: 'openstack endpoint create --region RegionOne network admin http://{{ controller }}:9696'
    - env: {{ salt['pillar.get']('openstack:env', {}) }}
#    - unless:
#      - openstack endpoint list --service network --interface admin

neutron-packages:
  pkg.installed:
    - pkgs:
      - openstack-neutron
      - openstack-neutron-ml2
      - openstack-neutron-linuxbridge
      - ebtables

/etc/neutron/neutron.conf:
  ini.options_present:
    - sections:
        DEFAULT:
          core_plugin: ml2
          service_plugins: ''
          transport_url: rabbit://openstack:{{ rabbit_pass }}@controller
          auth_strategy: keystone
          notify_nova_on_port_status_changes: true
          notify_nova_on_port_data_changes: true
        database:
          connection: 'mysql+pymysql://neutron:{{ neutron_dbpass }}@{{ mysql_host }}/neutron'
        keystone_authtoken:
          auth_uri: http://{{ controller }}:5000
          auth_url: http://{{ controller }}:35357
          memcached_servers: {{ controller }}:11211
          auth_type: password
          project_domain_name: default
          user_domain_name: default
          project_name: service
          username: neutron
          password: {{ neutron_pass }}
        nova:
          auth_url: http://{{ controller }}:35357
          auth_type: password
          project_domain_name: default
          user_domain_name: default
          region_name: RegionOne
          project_name: service
          username: nova
          password: {{ nova_pass }}
        oslo_concurrency:
          lock_path: /var/lib/neutron/tmp

/etc/neutron/plugins/ml2/ml2_conf.ini:
  ini.options_present:
    - sections:
        ml2:
          type_drivers: flat,vlan
          tenant_network_types: ''
          mechanism_drivers: linuxbridge
          extension_drivers: port_security
        ml2_type_flat:
          flat_networks: provider
        securitygroup:
          enable_ipset: true

/etc/neutron/plugins/ml2/linuxbridge_agent.ini:
  ini.options_present:
    - sections:
        linux_bridge:
          physical_interface_mappings: {{ provider_interface_name }}
        vxlan:
          enable_vxlan: false
        securitygroup:
          enable_security_group: true
          firewall_driver: neutron.agent.linux.iptables_firewall.IptablesFirewallDriver

/etc/neutron/dhcp_agent.ini:
  ini.options_present:
    - sections:
        DEFAULT:
          interface_driver: linuxbridge
          dhcp_driver: neutron.agent.linux.dhcp.Dnsmasq
          enable_isolated_metadata: true

/etc/neutron/metadata_agent.ini:
  ini.options_present:
    - sections:
        DEFAULT:
          nova_metadata_ip: {{ controller }}
          metadata_proxy_shared_secret: {{ metadata_secret }}

/etc/nova/nova.conf:
  ini.options_present:
    - sections:
        neutron:
          url: http://{{ controller }}:9696
          auth_url: http://{{ controller }}:35357
          auth_type: password
          project_domain_name: default
          user_domain_name: default
          region_name: RegionOne
          project_name: service
          username: neutron
          password: {{ neutron_pass }}
          service_metadata_proxy: true
          metadata_proxy_shared_secret: {{ metadata_secret }}

/etc/neutron/plugin.ini:
  file.symlink:
    - name: /etc/neutron/plugin.ini
    - target: /etc/neutron/plugins/ml2/ml2_conf.ini

neutron-db-manage:
  cmd.run:
    - name: "neutron-db-manage --config-file /etc/neutron/neutron.conf --config-file /etc/neutron/plugins/ml2/ml2_conf.ini upgrade head"
    - user: neutron
    - shell: /bin/sh

restart-compute:
  cmd.run:
    - name: systemctl restart openstack-nova-api

neutron-server:
  service.running:
    - enable: True

neutron-linuxbridge-agent:
  service.running:
    - enable: True
    - watch:
      - ini: /etc/neutron/plugins/ml2/linuxbridge_agent.ini

neutron-dhcp-agent:
  service.running:
    - enable: True
    - watch:
      - ini: /etc/neutron/dhcp_agent.ini

neutron-metadata-agent:
  service.running:
    - enable: True
    - watch:
      - ini: /etc/neutron/metadata_agent.ini


