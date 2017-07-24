
# Create glance user
#openstack user create --domain default --password glance glance

# Add the admin role to the glance user and service project:
#openstack role add --project service --user glance admin

# Create the glance service entity:
#openstack service create --name glance --description "OpenStack Image" image

# Create the Image service API endpoints
#openstack endpoint create --region RegionOne image public http://controller:9292
#openstack endpoint create --region RegionOne image internal http://controller:9292
#openstack endpoint create --region RegionOne image admin http://controller:9292


openstack image list

openstack image create "cirros" \
  --file ./images/cirros-0.3.4-x86_64-disk.img \
  --disk-format qcow2 --container-format bare \
  --public

openstack image list

