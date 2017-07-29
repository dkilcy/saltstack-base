
## Deploy OpenStack Ocela using SaltStack on RHEL/CentOS 7

Controller hostname is 'controller.lab.local'
Compute nodes are 'compute[12345].lab.local'

1. Configure the pillar

2. Configure the repo on all machines in the cluster, and install the python-openstackclient package

```
salt 'c*' state.sls openstack.yumrepo
```

3. Create the security methods

```
salt 'controller' state.sls openstack.auth
```

4. Install MariaDB and configure the database schema and users

```
salt 'controller' state.sls openstack.mysql
```

5. Install and configure the message queue and memcached services

```
salt 'controller' state.sls openstack.rabbitmq
salt 'controller' state.sls openstack.memcached
```

6. Create the Identity service

```
salt 'controller' state.sls openstack.keystone
```

Verify the installation

On the **controller** node, run these commands:

```
[root@controller openstack]$ pwd
/home/devops/openstack
[root@controller openstack]$ . auth-openrc.sh 
[root@controller openstack]$ . admin-openrc.sh 
[root@controller openstack]$ openstack project list
+----------------------------------+---------+
| ID                               | Name    |
+----------------------------------+---------+
| 049bc1d6c4924390840e3d94ecdff939 | admin   |
| 4169bbd85dc349d6ba22016115d83532 | service |
| dc908b893b3e4a5f95948a2781a5efb8 | demo    |
+----------------------------------+---------+
[root@controller openstack]$
[root@controller openstack]$ openstack project show service
+-------------+----------------------------------+
| Field       | Value                            |
+-------------+----------------------------------+
| description | Service Project                  |
| domain_id   | default                          |
| enabled     | True                             |
| id          | 4169bbd85dc349d6ba22016115d83532 |
| is_domain   | False                            |
| name        | service                          |
| parent_id   | default                          |
+-------------+----------------------------------+
[root@controller openstack]$ openstack role list
+----------------------------------+----------+
| ID                               | Name     |
+----------------------------------+----------+
| 37afbc37db3b490fb5a70d3317cc5440 | user     |
| 9fe2ff9ee4384b1894a90878d3e92bab | _member_ |
| b4a3340d4e8d4a6db580ceb63df89154 | admin    |
+----------------------------------+----------+
[root@controller openstack]$ openstack user list
+----------------------------------+-------+
| ID                               | Name  |
+----------------------------------+-------+
| a3c712f29e7e4101ba7b7eb1bbb57a28 | admin |
| a441ebf301124b3a8ab9ff36b23c16b9 | demo  |
+----------------------------------+-------+
[root@controller openstack]$ openstack user show demo
+---------------------+----------------------------------+
| Field               | Value                            |
+---------------------+----------------------------------+
| domain_id           | default                          |
| enabled             | True                             |
| id                  | a441ebf301124b3a8ab9ff36b23c16b9 |
| name                | demo                             |
| options             | {}                               |
| password_expires_at | None                             |
+---------------------+----------------------------------+
[root@controller openstack]$ openstack user show admin
+---------------------+----------------------------------+
| Field               | Value                            |
+---------------------+----------------------------------+
| domain_id           | default                          |
| enabled             | True                             |
| id                  | a3c712f29e7e4101ba7b7eb1bbb57a28 |
| name                | admin                            |
| options             | {}                               |
| password_expires_at | None                             |
+---------------------+----------------------------------+
[root@controller openstack]$ openstack service list
+----------------------------------+----------+----------+
| ID                               | Name     | Type     |
+----------------------------------+----------+----------+
| 173dcbf4b38746309d7b866f22916aad | keystone | identity |
+----------------------------------+----------+----------+
[root@controller openstack]$ openstack endpoint list
+----------------------------------+-----------+--------------+--------------+---------+-----------+-----------------------------+
| ID                               | Region    | Service Name | Service Type | Enabled | Interface | URL                         |
+----------------------------------+-----------+--------------+--------------+---------+-----------+-----------------------------+
| be8b723c4a924b04b7b9ad0af6c4d0a5 | RegionOne | keystone     | identity     | True    | public    | http://controller:5000/v3/  |
| ce44f744238746ad89d8295ff765131b | RegionOne | keystone     | identity     | True    | admin     | http://controller:35357/v3/ |
| e5ee3b36c3094c229057b312cf82d823 | RegionOne | keystone     | identity     | True    | internal  | http://controller:5000/v3/  |
+----------------------------------+-----------+--------------+--------------+---------+-----------+-----------------------------+

[root@controller openstack]$ 
[root@controller openstack]$ unset OS_AUTH_URL OS_PASSWORD
[root@controller openstack]$ openstack --os-auth-url http://controller:35357/v3 \
>   --os-project-domain-name default --os-user-domain-name default \
>   --os-project-name admin --os-username admin --os-password ${ADMIN_PASS} token issue
+------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Field      | Value                                                                                                                                                                                   |
+------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| expires    | 2017-07-29T16:59:41+0000                                                                                                                                                                |
| id         | gAAAAABZfLDtLq7EG6klU4nnQoeMypZx9AYC546VRQg2ljp-wbTW1Mh-R3JXqdhT5_JGiksv7zIF-K-rIu-geBRVD-_yfczIKWKQG19r86DCQOdedSYhKDePyVsbhNlF6_q1ZBmSMkYQ5r2-RgvD_pud8mortFnulh-5o5zpZ2cc1szGBsZJeco |
| project_id | 049bc1d6c4924390840e3d94ecdff939                                                                                                                                                        |
| user_id    | a3c712f29e7e4101ba7b7eb1bbb57a28                                                                                                                                                        |
+------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
[root@controller openstack]$ . demo-openrc.sh
[root@controller openstack]$ openstack --os-auth-url http://controller:5000/v3 \
>   --os-project-domain-name default --os-user-domain-name default \
>   --os-project-name demo --os-username demo token issue
+------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Field      | Value                                                                                                                                                                                   |
+------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| expires    | 2017-07-29T17:00:04+0000                                                                                                                                                                |
| id         | gAAAAABZfLEEuf1UDfHePlfO3FUvWONuG3qQi_u6ylrBbXL6LqCPO8CkbO49By3f2UW15AOp6VhD5Y9sWaFRZ5-v9gH_M6g0rIk40-b7ZqlGFFw6PbYDbiDgta1ifJVMz7DVz33aMnHbxuOfjEEftVPEmkNB-deKEhkYeh0qj_eLClwvRN3aWXI |
| project_id | dc908b893b3e4a5f95948a2781a5efb8                                                                                                                                                        |
| user_id    | a441ebf301124b3a8ab9ff36b23c16b9                                                                                                                                                        |
+------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
```

7. Create the Image service

```
salt 'controller' state.sls openstack.glance
```

Verify the installation

On the **controller** node, run these commands:

```
[root@controller openstack]$ pwd
/home/devops/openstack
[root@controller openstack]$ . admin-openrc.sh
[root@controller openstack]$ openstack user list
+----------------------------------+--------+
| ID                               | Name   |
+----------------------------------+--------+
| 448318f93f0c4999acf158218b043587 | glance |
| a3c712f29e7e4101ba7b7eb1bbb57a28 | admin  |
| a441ebf301124b3a8ab9ff36b23c16b9 | demo   |
+----------------------------------+--------+
[root@controller openstack]$ openstack user show glance
+---------------------+----------------------------------+
| Field               | Value                            |
+---------------------+----------------------------------+
| domain_id           | default                          |
| enabled             | True                             |
| id                  | 448318f93f0c4999acf158218b043587 |
| name                | glance                           |
| options             | {}                               |
| password_expires_at | None                             |
+---------------------+----------------------------------+
[root@controller openstack]$ openstack service list
+----------------------------------+----------+----------+
| ID                               | Name     | Type     |
+----------------------------------+----------+----------+
| 173dcbf4b38746309d7b866f22916aad | keystone | identity |
| b90926a8a570403cbecd40064ac4b998 | glance   | image    |
+----------------------------------+----------+----------+
[root@controller openstack]$ openstack service show glance
+-------------+----------------------------------+
| Field       | Value                            |
+-------------+----------------------------------+
| description | OpenStack Image service          |
| enabled     | True                             |
| id          | b90926a8a570403cbecd40064ac4b998 |
| name        | glance                           |
| type        | image                            |
+-------------+----------------------------------+
[root@controller openstack]$ openstack endpoint list
+----------------------------------+-----------+--------------+--------------+---------+-----------+-----------------------------+
| ID                               | Region    | Service Name | Service Type | Enabled | Interface | URL                         |
+----------------------------------+-----------+--------------+--------------+---------+-----------+-----------------------------+
| 042e0ce8faf54468a69bd83b247f3c49 | RegionOne | glance       | image        | True    | public    | http://controller:9292      |
| 22d73d997d964a40801d12dd30500acf | RegionOne | glance       | image        | True    | internal  | http://controller:9292      |
| b2af4c8f265f4a2798626e3cfce128da | RegionOne | glance       | image        | True    | admin     | http://controller:9292      |
| be8b723c4a924b04b7b9ad0af6c4d0a5 | RegionOne | keystone     | identity     | True    | public    | http://controller:5000/v3/  |
| ce44f744238746ad89d8295ff765131b | RegionOne | keystone     | identity     | True    | admin     | http://controller:35357/v3/ |
| e5ee3b36c3094c229057b312cf82d823 | RegionOne | keystone     | identity     | True    | internal  | http://controller:5000/v3/  |
+----------------------------------+-----------+--------------+--------------+---------+-----------+-----------------------------+
[root@controller openstack]$
[root@controller openstack]$ ls -l ./images/
total 13335480
-rw-r--r-- 1 devops devops   731185152 Jul 22 23:08 CentOS-6-x86_64-GenericCloud-1601.qcow2
-rw-r--r-- 1 devops devops   910032896 Jul 22 23:08 CentOS-7-x86_64-GenericCloud-1601.qcow2
-rw-r--r-- 1 devops devops    13287936 Jul 22 23:08 cirros-0.3.4-x86_64-disk.img
-rw-r--r-- 1 devops devops 12001017856 Jul 27 14:48 windows_server_2012_r2_standard_eval_kvm_20170321.qcow2
[root@controller openstack]$ 
[root@controller openstack]$ openstack image create "cirros-0.3.4" \
>   --file ./images/cirros-0.3.4-x86_64-disk.img \
>   --disk-format qcow2 --container-format bare \
>   --public
+------------------+------------------------------------------------------+
| Field            | Value                                                |
+------------------+------------------------------------------------------+
| checksum         | ee1eca47dc88f4879d8a229cc70a07c6                     |
| container_format | bare                                                 |
| created_at       | 2017-07-29T16:10:36Z                                 |
| disk_format      | qcow2                                                |
| file             | /v2/images/22a2efef-29fb-4221-a38a-695b56bfddf2/file |
| id               | 22a2efef-29fb-4221-a38a-695b56bfddf2                 |
| min_disk         | 0                                                    |
| min_ram          | 0                                                    |
| name             | cirros-0.3.4                                         |
| owner            | 049bc1d6c4924390840e3d94ecdff939                     |
| protected        | False                                                |
| schema           | /v2/schemas/image                                    |
| size             | 13287936                                             |
| status           | active                                               |
| tags             |                                                      |
| updated_at       | 2017-07-29T16:10:37Z                                 |
| virtual_size     | None                                                 |
| visibility       | public                                               |
+------------------+------------------------------------------------------+
[root@controller openstack]$ openstack image list
+--------------------------------------+--------------+--------+
| ID                                   | Name         | Status |
+--------------------------------------+--------------+--------+
| 22a2efef-29fb-4221-a38a-695b56bfddf2 | cirros-0.3.4 | active |
+--------------------------------------+--------------+--------+
```



5. Create the Compute Service 

```
salt 'controller' state.sls openstack.nova.controller
```

Verify novacello0 and cell1 are registered correctly
```
nova-manage cell_v2 list_cellsrm n
```

```
salt 'compute1' state.sls openstack.nova.compute
```

```
openstack hypervisor list
su -s /bin/sh -c "nova-manage cell_v2 discover_hosts --verbose" nova
openstack compute service list
openstack catalog list
openstack image list
nova-status upgrade check
```


8. Create the Networking service 

```
salt 'controller' state.sls openstack.neutron.controller
```

```
salt 'compute1' state.sls openstack.neutron.compute
```

```
openstack extension list --network
openstack network agent list
openstack network list
```

### Verifying the Installation



### Post-Install

1. Create default flavors

  ```
  openstack flavor create --id 0 --vcpus 1 --ram 64    --disk 1   m1.nano
  openstack flavor create --id 1 --vcpus 1 --ram 512   --disk 1   m1.tiny
  openstack flavor create --id 2 --vcpus 1 --ram 2048  --disk 20  m1.small
  openstack flavor create --id 3 --vcpus 2 --ram 4096  --disk 30  m1.medium
  openstack flavor create --id 4 --vcpus 4 --ram 8192  --disk 40  m1.large
  openstack flavor create --id 5 --vcpus 8 --ram 16384 --disk 80  m1.xlarge
  
  openstack flavor list
  ```

2. Create security groups

  Create the new security group:
  ```
  openstack security group create windows-default
  openstack security group rule create --proto icmp windows-default
  openstack security group rule create --proto tcp --dst-port 3389 windows-default
  
  openstack security group create linux-default
  openstack security group rule create --proto icmp linux-default
  openstack security group rule create --proto tcp --dst-port 22 linux-default
  openstack security group rule create --proto tcp --dst-port 80 linux-default
  openstack security group rule create --proto tcp --dst-port 443 linux-default
  
  openstack security group list
  ```

4. Add the public key for the devops user to the key store
  ```
  openstack keypair create --public-key /home/devops/.ssh/id_rsa.pub devops-key
  openstack keypair list
  ```
  
5. Create provider network and subnet
```
openstack network create  --share --external  \
  --provider-physical-network provider  \
  --provider-network-type flat provider
  
openstack network list

openstack subnet create --network provider \
  --allocation-pool start=10.0.0.200,end=10.0.0.216 \
  --dns-nameserver 10.0.0.6 \
  --gateway 10.0.0.1 \
  --subnet-range 10.0.0.0/24 provider
  
openstack subnet list
```

3. Create test instance

```
. demo-openrc.sh
openstack server create --flavor m1.nano --image cirros-0.3.4 \
  --nic net-id=bad3be29-b22a-4e3e-bd6a-fb855d5ad652  \
  --security-group default \
  --key-name devops-key test-instance
  
openstack server list
openstack console url show test-instance
ping 10.0.0.207 
```

#### Services to check on the controller

```
systemctl status httpd.service
systemctl status mariadb.service
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

Run the clean-all.sh script on the Salt master

```
[root@ws2 openstack]$ time ./clean-all.sh 
This is going to destroy the OpenStack cluster
You have 10 seconds to abort....
...
real	2m17.222s
user	0m4.964s
sys	0m0.452s
```


