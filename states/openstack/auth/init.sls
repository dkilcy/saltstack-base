{% set controller = salt['pillar.get']('openstack:controller:host') %}

dir_setup:
  file.directory:
    - name: {{ salt['pillar.get']('openstack:tools_dir') }}
    - user: {{ salt['pillar.get']('openstack:user') }}
    - group: {{ salt['pillar.get']('openstack:user') }}
    - mode: 775

auth_setup:
  file.managed:
    - name: {{ salt['pillar.get']('openstack:tools_dir') }}/auth-openrc.sh
    - user: {{ salt['pillar.get']('openstack:user') }}
    - group: {{ salt['pillar.get']('openstack:user') }}
    - mode: 755 
    - create: True
    - contents: |
        export ADMIN_PASS={{ salt['pillar.get']('openstack:auth:ADMIN_PASS') }}
        export CINDER_DBPASS={{ salt['pillar.get']('openstack:auth:CINDER_DBPASS') }}
        export CINDER_PASS={{ salt['pillar.get']('openstack:auth:CINDER_PASS') }}
        export DASH_DBPASS={{ salt['pillar.get']('openstack:auth:DASH_DBPASS') }}
        export DEMO_PASS={{ salt['pillar.get']('openstack:auth:DEMO_PASS') }}
        export GLANCE_DBPASS={{ salt['pillar.get']('openstack:auth:GLANCE_DBPASS') }}
        export GLANCE_PASS={{ salt['pillar.get']('openstack:auth:GLANCE_PASS') }}
        export KEYSTONE_DBPASS={{ salt['pillar.get']('openstack:auth:KEYSTONE_DBPASS') }}
        export METADATA_SECRET={{ salt['pillar.get']('openstack:auth:METADATA_SECRET') }}
        export NEUTRON_DBPASS={{ salt['pillar.get']('openstack:auth:NEUTRON_DBPASS') }}
        export NEUTRON_PASS={{ salt['pillar.get']('openstack:auth:NEUTRON_PASS') }}
        export NOVA_DBPASS={{ salt['pillar.get']('openstack:auth:NOVA_DBPASS') }}
        export NOVA_PASS={{ salt['pillar.get']('openstack:auth:NOVA_PASS') }}
        export PLACEMENT_PASS={{ salt['pillar.get']('openstack:auth:PLACEMENT_PASS') }}
        export RABBIT_PASS={{ salt['pillar.get']('openstack:auth:RABBIT_PASS') }}

admin_setup:
  file.managed:
    - name: {{ salt['pillar.get']('openstack:tools_dir') }}/admin-openrc.sh
    - user: {{ salt['pillar.get']('openstack:user') }}
    - group: {{ salt['pillar.get']('openstack:user') }}
    - mode: 755 
    - create: True
    - contents: |
        export OS_USERNAME=admin
        export OS_PASSWORD=$ADMIN_PASS
        export OS_PROJECT_NAME=admin
        export OS_USER_DOMAIN_NAME=Default
        export OS_PROJECT_DOMAIN_NAME=Default
        export OS_AUTH_URL=http://{{ controller }}:35357/v3
        export OS_IDENTITY_API_VERSION=3

#demo_setup:
#  file.managed:
#    - name: {{ salt['pillar.get']('openstack:tools_dir') }}/demo-openrc.sh
#    - user: {{ salt['pillar.get']('openstack:user') }}
#    - group: {{ salt['pillar.get']('openstack:user') }}
#    - mode: 755 
#    - contents: |
#        export OS_PROJECT_DOMAIN_ID=default
#        export OS_USER_DOMAIN_ID=default
#        export OS_PROJECT_NAME=demo
#        export OS_TENANT_NAME=demo
#        export OS_USERNAME=demo
#        export OS_PASSWORD=$DEMO_PASS
#        export OS_AUTH_URL=http://{{ controller }}:5000/v3
#        export OS_IMAGE_API_VERSION=2
#        export OS_REGION_NAME=RegionOne


