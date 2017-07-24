
# Create the nova user
#openstack user create --domain default --password nova nova

# Add the admin role to the nova user
#openstack role add --project service --user nova admin

# Create the nova service entry
#openstack service create --name nova --description "OpenStack Compute" compute

# Create the Compute API service endpoints
#openstack endpoint create --region RegionOne compute public http://controller:8774/v2.1
#openstack endpoint create --region RegionOne compute internal http://controller:8774/v2.1
#openstack endpoint create --region RegionOne compute admin http://controller:8774/v2.1

# Create a Placement service
#openstack user create --domain default --password placement placement

# Add the Placement user to the service project with the admin role
#openstack role add --project service --user placement admin

# Create the Placement API entry in the service catalog
#openstack service create --name placement --description "Placement API" placement

# Create the Placement API service endpoints
#openstack endpoint create --region RegionOne placement public http://controller:8778
#openstack endpoint create --region RegionOne placement internal http://controller:8778
#openstack endpoint create --region RegionOne placement admin http://controller:8778

# Verify novacello0 and cell1 are registered correctly
nova-manage cell_v2 list_cells

