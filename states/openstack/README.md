
## Deploy OpenStack Ocela using SaltStack on CentOS 7


1. Configure the pillar

2.

```
salt 'controller' state.sls openstack.yumrepo
salt 'compute1' state.sls openstack.yumrepo
```

```
salt 'controller' state.sls openstack.auth
salt 'controller' state.sls openstack.mysql
salt 'controller' state.sls openstack.rabbitmq
salt 'controller' state.sls openstack.memcached
```

3. 

```
salt 'controller' state.sls openstack.keystone
```

```
keystone.sh
```


4. 

```
salt 'controller' state.sls openstack.glance
```

```
glance.sh
```

5. 

```
salt 'controller' state.sls openstack.nova.controller
```

6. 

```
salt 'compute1' state.sls openstack.nova.compute
```

8. 

```
salt 'controller' state.sls openstack.neutron.controller
```

9. 

```
salt 'compute1' state.sls openstack.neutron.compute


### Verifying the Installation


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
mum -y erase memcached
yum -y erase rabbitmq-server

yum -y erase mariadb
rm -Rf /var/lib/mysql
rm -Rf /etc/my.cnf.db




```

