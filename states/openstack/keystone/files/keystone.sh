#!/bin/bash
#
# https://docs.openstack.org/ocata/install-guide-rdo/keystone-users.html
#

# Create Service project
openstack project create --domain default --description "Service Project" service

# Create Demo project
openstack project create --domain default --description "Demo Project" demo

# Create Demo user
openstack user create --domain default --password demo demo

# Create User role
openstack role create user

# Add user role to demo user of demo project
openstack role add --project demo --user demo user

