
{% from "mysql/map.jinja" import mysql with context %}

{% set rabbit_pass = salt['pillar.get']('openstack:auth:RABBIT_PASS') %}
{% set nova_pass = salt['pillar.get']('openstack:auth:NOVA_PASS') %}
{% set placement_pass = salt['pillar.get']('openstack:auth:PLACEMENT_PASS') %}

{% set controller = salt['pillar.get']('openstack:controller:host') %}

openstack-nova-compute-pkgs:
  pkg.installed:
    - pkgs:
      - openstack-nova-compute

/etc/nova/nova.conf:
  ini.options_present:
    - sections:
        DEFAULT:
          enabled_apis: osapi_compute,metadata
          transport_url: rabbit://openstack:{{ rabbit_pass }}@{{ controller }}
          my_ip: {{ salt['grains.get']('fqdn_ip4:0') }}
          use_neutron: True
          firewall_driver: nova.virt.firewall.NoopFirewallDriver
        api:
          auth_strategy: keystone
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
          vncserver_listen: 0.0.0.0
          vncserver_proxyclient_address: $my_ip
          novncproxy_base_url: http://{{ controller }}:6080/vnc_auto.html
        glance:
          api_servers: http://{{ controller }}:9292
        oslo_concurrency:
          lock_path: /var/lib/nova/tmp
        placement:
          os_region_name: RegionOne
          project_domain_name: Default
          project_name: service
          auth_type: password
          user_domain_name: Default
          auth_url: http://{{ controller }}:35357/v3
          username: placement
          password: {{ placement_pass }}

libvirtd-service:
  service.running:
    - name: libvirtd
    - enable: True

openstack-nova-compute-service:
  service.running:
    - name: openstack-nova-compute
    - enable: True
    - watch:
      - ini: /etc/nova/nova.conf

