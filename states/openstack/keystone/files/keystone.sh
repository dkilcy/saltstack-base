#!/bin/bash
#
# https://docs.openstack.org/ocata/install-guide-rdo/keystone-users.html
#

. auth-openrc.sh
. admin-openrc.sh

# Create Service project
#openstack project create --domain default --description "Service Project" service

# Create Demo project
#openstack project create --domain default --description "Demo Project" demo

# Create Demo user
#openstack user create --domain default --password demo demo

# Create User role
#openstack role create user

# Add user role to demo user of demo project
#openstack role add --project demo --user demo user

#
# https://docs.openstack.org/ocata/install-guide-rdo/keystone-verify.html
#

openstack project list
openstack project show service

openstack role list

openstack user list
openstack user show demo

openstack service list
openstack endpoint list

#
#
#

unset OS_AUTH_URL OS_PASSWORD

openstack --os-auth-url http://controller:35357/v3 \
  --os-project-domain-name default --os-user-domain-name default \
  --os-project-name admin --os-username admin --os-password ${ADMIN_PASS} token issue

. demo-openrc.sh

openstack --os-auth-url http://controller:5000/v3 \
  --os-project-domain-name default --os-user-domain-name default \
  --os-project-name demo --os-username demo token issue


. admin-openrc.sh

