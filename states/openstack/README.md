
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
openstack network create  --share --external  \
  --provider-physical-network provider  \
  --provider-network-type flat provider
openstack subnet create --network provider \
  --allocation-pool start=10.0.0.200,end=10.0.0.216 \
  --dns-nameserver 10.0.0.6 \
  --gateway 10.0.0.1 \
  --subnet-range 10.0.0.0/24 provider
openstack flavor create --id 0 --vcpus 1 --ram 64 --disk 1 m1.nano
openstack flavor list
openstack image list
openstack network list
openstack security group list
openstack server create --flavor m1.nano --image cirros \
  --nic net-id=bad3be29-b22a-4e3e-bd6a-fb855d5ad652  \
  --security-group default \
  --key-name mykey provider-instance
openstack server list
openstack console url show provider-instance
ping 10.0.0.207 
```

### Post-Install

1. Create default flavors

  ```
  openstack flavor create --id 0 --vcpus 1 --ram 64    --disk 1   m1.nano
  openstack flavor create --id 1 --vcpus 1 --ram 512   --disk 1   m1.tiny
  openstack flavor create --id 2 --vcpus 1 --ram 2048  --disk 20  m1.small
  openstack flavor create --id 3 --vcpus 2 --ram 4096  --disk 30  m1.medium
  openstack flavor create --id 4 --vcpus 4 --ram 8192  --disk 40  m1.large
  openstack flavor create --id 5 --vcpus 8 --ram 16384 --disk 80  m1.xlarge
  ```

#### Services to check on the controller

```
systemctl status httpd.service
systemctl status mariadb.service
systemctl status mongod.service
systemctl status mongod.service
systemctl status memcached.service
systemctl status openstack-glance-api.service \
 openstack-glance-registry.service
systemctl status openstack-nova-api.service \
 openstack-nova-cert.service \
 openstack-nova-consoleauth.service \
 openstack-nova-scheduler.service \
 openstack-nova-conductor.service \
 openstack-nova-novncproxy.service
systemctl status openstack-nova-api
systemctl status neutron-server.service \
 neutron-linuxbridge-agent.service \
 neutron-dhcp-agent.service \
 neutron-metadata-agent.service
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

