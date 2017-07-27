#!/bin/bash

openstack hypervisor list

su -s /bin/sh -c "nova-manage cell_v2 discover_hosts --verbose" nova

openstack compute service list

openstack catalog list

openstack image list

nova-status upgrade check


