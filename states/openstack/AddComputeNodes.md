
## Add Compute Nodes


1. From the controller, add the server to the cluster

```
salt 'compute2' state.sls  openstack.nova.compute
```

2. Confirm compute node is in the database

```
. admin-openrc.sh
openstack hypervisor list
openstack compute service list
```

3. 
