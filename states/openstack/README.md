
## Deploy OpenStack Ocela using SaltStack on RHEL/CentOS 7



1. Configure the pillar


2. Configure the repo on all machines in the cluster, and install the python-openstackclient package

```
salt 'c*' state.sls openstack.yumrepo
```

3. Setup the Environment


  a. Create the security methods
  ```
  salt 'controller' state.sls openstack.auth
  ```

  b. Install MariaDB and configure the database schema and users
  ```
  salt 'controller' state.sls openstack.mysql
  ```

  c. Install and configure the message queue and memcached services
  ```
  salt 'controller' state.sls openstack.rabbitmq
  salt 'controller' state.sls openstack.memcached
  ```

4. Create the Identity service

```
salt 'controller' state.sls openstack.keystone
```

```
keystone.sh
```


4. Create the Image service

```
salt 'controller' state.sls openstack.glance
```

```
glance.sh
```

5. Create the Compute Service 

```
salt 'controller' state.sls openstack.nova.controller
```

```
nova-controller.sh
```

```
salt 'compute1' state.sls openstack.nova.compute
```

```
nova-compute.sh
```


8. Create the Networking service 

```
salt 'controller' state.sls openstack.neutron.controller
```

```
salt 'compute1' state.sls openstack.neutron.compute
```

```
neutron-compute.sh
```

### Verifying the Installation

```
. ./admin-openrc.sh
openstack extension list --network
openstack network agent list
openstack flavor create --id 0 --vcpus 1 --ram 64 --disk 1 m1.nano
. ./demo-openrc.sh 
openstack keypair create --public-key ~/.ssh/id_rsa.pub mykey
openstack keypair list
openstack security group rule create --proto icmp default
openstack security group rule create --proto tcp --dst-port 22 default
openstack network create  --share --external   --provider-physical-network provider   --provider-network-type flat provider
openstack subnet create --network provider --allocation-pool start=10.0.0.200,end=10.0.0.216   --dns-nameserver 10.0.0.6 --gateway 10.0.0.1 --subnet-range 10.0.0.0/24 provider
openstack flavor create --id 0 --vcpus 1 --ram 64 --disk 1 m1.nano
openstack flavor list
openstack image list
openstack network list
openstack security group list
openstack server create --flavor m1.nano --image cirros   --nic net-id=bad3be29-b22a-4e3e-bd6a-fb855d5ad652  --security-group default   --key-name mykey provider-instance
openstack server list
openstack console url show provider-instance
ping 10.0.0.207 
```

### Cleanup

1. Compute and Controller

```
yum -y erase \*openstack\*
yum -y erase libvirtd

rm -Rf /etc/nova
rm -Rf /etc/neutron
rm -Rf /etc/keystone
rm -Rf /etc/glance

rm -Rf /var/log/keystone
rm -Rf /var/log/glance
rm -Rf /var/log/nova
rm -Rf /var/log/neutron
```

2. Controller
```
yum -y erase mod_wsgi
yum -y erase httpd
rm -Rf /etc/httpd

yum -y erase memcached
yum -y erase rabbitmq-server

yum -y erase mariadb
rm -Rf /var/lib/mysql

rm -Rf /etc/my.cnf.db
rm -Rf /var/log/httpd
```

