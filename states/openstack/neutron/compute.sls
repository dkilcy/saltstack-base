# 
# https://docs.openstack.org/ocata/install-guide-rdo/neutron-controller-install.html
#

{% from "openstack/mysql/map.jinja" import mysql with context %}

{% set mysql_host = salt['pillar.get']('openstack:controller:host') %}

{% set neutron_dbpass = salt['pillar.get']('openstack:auth:NEUTRON_DBPASS') %}
{% set neutron_pass = salt['pillar.get']('openstack:auth:NEUTRON_PASS') %}
{% set nova_pass = salt['pillar.get']('openstack:auth:NOVA_PASS') %}
{% set rabbit_pass = salt['pillar.get']('openstack:auth:RABBIT_PASS') %}
{% set metadata_secret = salt['pillar.get']('openstack:auth:METADATA_SECRET') %}
{% set provider_interface_name = salt['pillar.get']('openstack:neutron:compute_provider_interface_name') %}
{% set controller = salt['pillar.get']('openstack:controller:host') %}

neutron-compute-packages:
  pkg.installed:
    - pkgs:
      - openstack-neutron-linuxbridge
      - ebtables
      - ipset

/etc/neutron/neutron.conf:
  ini.options_present:
    - sections:
        DEFAULT:
          transport_url: rabbit://openstack:{{ rabbit_pass }}@controller
          auth_strategy: keystone
#        database:
#          connection: ''
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
        oslo_concurrency:
          lock_path: /var/lib/neutron/tmp

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
#          service_metadata_proxy: true
#          metadata_proxy_shared_secret: {{ metadata_secret }}

restart-compute:
  cmd.run:
    - name: systemctl restart openstack-nova-compute

neutron-linuxbridge-agent:
  service.running:
    - enable: True


