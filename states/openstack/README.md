
## Deploy OpenStack Ocata using SaltStack on RHEL/CentOS 7

https://docs.openstack.org/ocata/install-guide-rdo/index.html

Controller hostname is 'controller.lab.local'
Compute nodes are 'compute[12345].lab.local'

Where to get cloud images: [RDO Image resources](https://openstack.redhat.com/resources/image-resources/)

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

##### Verify the installation

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

##### Verify the installation

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

8. Create the Compute Service on the Controller

```
salt 'controller' state.sls openstack.nova.controller
```

##### Verify the installation

On the **controller** node, run these commands:

Verify nova cell0 and cell1 are registered correctly
```
[root@controller openstack]$ nova-manage cell_v2 list_cells
+-------+--------------------------------------+
|  Name |                 UUID                 |
+-------+--------------------------------------+
| cell0 | 00000000-0000-0000-0000-000000000000 |
| cell1 | d86e225e-6673-456e-b158-8dedce9bdee1 |
+-------+--------------------------------------+
```

Verify the creation of the service and endpoints
```
[root@controller openstack]$ openstack service list
+----------------------------------+-----------+-----------+
| ID                               | Name      | Type      |
+----------------------------------+-----------+-----------+
| 173dcbf4b38746309d7b866f22916aad | keystone  | identity  |
| 4d4c293d9b5243f6a3a498fcc4d44ffb | nova      | compute   |
| ad5b11bfda874556927d04450daa58bc | placement | placement |
| b90926a8a570403cbecd40064ac4b998 | glance    | image     |
+----------------------------------+-----------+-----------+
[root@controller openstack]$ openstack endpoint list
+----------------------------------+-----------+--------------+--------------+---------+-----------+-----------------------------+
| ID                               | Region    | Service Name | Service Type | Enabled | Interface | URL                         |
+----------------------------------+-----------+--------------+--------------+---------+-----------+-----------------------------+
| 042e0ce8faf54468a69bd83b247f3c49 | RegionOne | glance       | image        | True    | public    | http://controller:9292      |
| 229c401ca08b46e094860a27c91c475c | RegionOne | placement    | placement    | True    | public    | http://controller:8778      |
| 22d73d997d964a40801d12dd30500acf | RegionOne | glance       | image        | True    | internal  | http://controller:9292      |
| 445aae310fdf4b43bb6b05e6202cfba2 | RegionOne | nova         | compute      | True    | admin     | http://controller:8774/v2.1 |
| 83b7b5fbba274305aed5aa8bc1f44688 | RegionOne | placement    | placement    | True    | internal  | http://controller:8778      |
| b2af4c8f265f4a2798626e3cfce128da | RegionOne | glance       | image        | True    | admin     | http://controller:9292      |
| be8b723c4a924b04b7b9ad0af6c4d0a5 | RegionOne | keystone     | identity     | True    | public    | http://controller:5000/v3/  |
| ce44f744238746ad89d8295ff765131b | RegionOne | keystone     | identity     | True    | admin     | http://controller:35357/v3/ |
| df542af1bf644eea8aeb67064112bdaf | RegionOne | nova         | compute      | True    | internal  | http://controller:8774/v2.1 |
| e5ee3b36c3094c229057b312cf82d823 | RegionOne | keystone     | identity     | True    | internal  | http://controller:5000/v3/  |
| fac5bf3381364285a9311ba10945fb25 | RegionOne | placement    | placement    | True    | admin     | http://controller:8778      |
| fe495bcd1f9f43cd83fcb42321b8ba18 | RegionOne | nova         | compute      | True    | public    | http://controller:8774/v2.1 |
+----------------------------------+-----------+--------------+--------------+---------+-----------+-----------------------------+
```

9. Create the Compute Service on the Compute Nodes
```
salt 'compute*' state.sls openstack.nova.compute
```

##### Finalize the Installation

Confirm there are compute nodes in the database, and discover them.

On the **controller** node, run these commands:

```
[root@controller openstack]$ openstack hypervisor list
+----+---------------------+-----------------+-----------+-------+
| ID | Hypervisor Hostname | Hypervisor Type | Host IP   | State |
+----+---------------------+-----------------+-----------+-------+
|  1 | compute4.lab.local  | QEMU            | 10.0.0.34 | up    |
|  2 | compute5.lab.local  | QEMU            | 10.0.0.35 | up    |
|  3 | compute3.lab.local  | QEMU            | 10.0.0.33 | up    |
|  4 | compute1.lab.local  | QEMU            | 10.0.0.31 | up    |
|  5 | compute2.lab.local  | QEMU            | 10.0.0.32 | up    |
+----+---------------------+-----------------+-----------+-------+
[root@controller openstack]$ su -s /bin/sh -c "nova-manage cell_v2 discover_hosts --verbose" nova
Found 2 cell mappings.
Skipping cell0 since it does not contain hosts.
Getting compute nodes from cell 'cell1': d86e225e-6673-456e-b158-8dedce9bdee1
Found 5 computes in cell: d86e225e-6673-456e-b158-8dedce9bdee1
Checking host mapping for compute host 'compute4.lab.local': f9590fe5-607e-48cd-a2f6-7d5fecb798ee
Creating host mapping for compute host 'compute4.lab.local': f9590fe5-607e-48cd-a2f6-7d5fecb798ee
Checking host mapping for compute host 'compute5.lab.local': 464f56d5-3b07-4e73-82e1-f871994b94d9
Creating host mapping for compute host 'compute5.lab.local': 464f56d5-3b07-4e73-82e1-f871994b94d9
Checking host mapping for compute host 'compute3.lab.local': 9f5498b2-9da9-4bea-ac2c-d0f0ca125ca4
Creating host mapping for compute host 'compute3.lab.local': 9f5498b2-9da9-4bea-ac2c-d0f0ca125ca4
Checking host mapping for compute host 'compute1.lab.local': ab68adb6-e8de-4cbf-b52e-23c336c1bb67
Creating host mapping for compute host 'compute1.lab.local': ab68adb6-e8de-4cbf-b52e-23c336c1bb67
Checking host mapping for compute host 'compute2.lab.local': d492fe92-5913-498c-8264-508ec0a1ee3c
Creating host mapping for compute host 'compute2.lab.local': d492fe92-5913-498c-8264-508ec0a1ee3c
[root@controller openstack]$
```

##### Verify the installation

On the **controller** node, run these commands:

```
[root@controller openstack]$ openstack compute service list
+----+------------------+----------------------+----------+---------+-------+----------------------------+
| ID | Binary           | Host                 | Zone     | Status  | State | Updated At                 |
+----+------------------+----------------------+----------+---------+-------+----------------------------+
|  3 | nova-consoleauth | controller.lab.local | internal | enabled | up    | 2017-07-29T16:59:25.000000 |
|  4 | nova-scheduler   | controller.lab.local | internal | enabled | up    | 2017-07-29T16:59:29.000000 |
|  5 | nova-conductor   | controller.lab.local | internal | enabled | up    | 2017-07-29T16:59:23.000000 |
|  7 | nova-compute     | compute4.lab.local   | nova     | enabled | up    | 2017-07-29T16:59:29.000000 |
|  8 | nova-compute     | compute5.lab.local   | nova     | enabled | up    | 2017-07-29T16:59:20.000000 |
|  9 | nova-compute     | compute3.lab.local   | nova     | enabled | up    | 2017-07-29T16:59:21.000000 |
| 10 | nova-compute     | compute1.lab.local   | nova     | enabled | up    | 2017-07-29T16:59:29.000000 |
| 11 | nova-compute     | compute2.lab.local   | nova     | enabled | up    | 2017-07-29T16:59:20.000000 |
+----+------------------+----------------------+----------+---------+-------+----------------------------+
[root@controller openstack]$ openstack catalog list
+-----------+-----------+-----------------------------------------+
| Name      | Type      | Endpoints                               |
+-----------+-----------+-----------------------------------------+
| keystone  | identity  | RegionOne                               |
|           |           |   public: http://controller:5000/v3/    |
|           |           | RegionOne                               |
|           |           |   admin: http://controller:35357/v3/    |
|           |           | RegionOne                               |
|           |           |   internal: http://controller:5000/v3/  |
|           |           |                                         |
| nova      | compute   | RegionOne                               |
|           |           |   admin: http://controller:8774/v2.1    |
|           |           | RegionOne                               |
|           |           |   internal: http://controller:8774/v2.1 |
|           |           | RegionOne                               |
|           |           |   public: http://controller:8774/v2.1   |
|           |           |                                         |
| placement | placement | RegionOne                               |
|           |           |   public: http://controller:8778        |
|           |           | RegionOne                               |
|           |           |   internal: http://controller:8778      |
|           |           | RegionOne                               |
|           |           |   admin: http://controller:8778         |
|           |           |                                         |
| glance    | image     | RegionOne                               |
|           |           |   public: http://controller:9292        |
|           |           | RegionOne                               |
|           |           |   internal: http://controller:9292      |
|           |           | RegionOne                               |
|           |           |   admin: http://controller:9292         |
|           |           |                                         |
+-----------+-----------+-----------------------------------------+
[root@controller openstack]$ openstack image list
+--------------------------------------+--------------+--------+
| ID                                   | Name         | Status |
+--------------------------------------+--------------+--------+
| 22a2efef-29fb-4221-a38a-695b56bfddf2 | cirros-0.3.4 | active |
+--------------------------------------+--------------+--------+
[root@controller openstack]$ nova-status upgrade check
+---------------------------+
| Upgrade Check Results     |
+---------------------------+
| Check: Cells v2           |
| Result: Success           |
| Details: None             |
+---------------------------+
| Check: Placement API      |
| Result: Success           |
| Details: None             |
+---------------------------+
| Check: Resource Providers |
| Result: Success           |
| Details: None             |
+---------------------------+
```

10. Create the Networking service on the Controller

```
salt 'controller' state.sls openstack.neutron.controller
```

11. Create the Networking service on the Compute nodes

```
salt 'compute*' state.sls openstack.neutron.compute
```

##### Verify the installation

On the **controller** node, run these commands:

```
[root@controller openstack]$ openstack extension list --network
+-------------------------------------------------------------+---------------------------+----------------------------------------------------------------------------------------------------------------------------+
| Name                                                        | Alias                     | Description                                                                                                                |
+-------------------------------------------------------------+---------------------------+----------------------------------------------------------------------------------------------------------------------------+
| Default Subnetpools                                         | default-subnetpools       | Provides ability to mark and use a subnetpool as the default                                                               |
| Availability Zone                                           | availability_zone         | The availability zone extension.                                                                                           |
| Network Availability Zone                                   | network_availability_zone | Availability zone support for network.                                                                                     |
| Port Binding                                                | binding                   | Expose port bindings of a virtual port to external application                                                             |
| agent                                                       | agent                     | The agent management extension.                                                                                            |
| Subnet Allocation                                           | subnet_allocation         | Enables allocation of subnets from a subnet pool                                                                           |
| DHCP Agent Scheduler                                        | dhcp_agent_scheduler      | Schedule networks among dhcp agents                                                                                        |
| Tag support                                                 | tag                       | Enables to set tag on resources.                                                                                           |
| Neutron external network                                    | external-net              | Adds external network attribute to network resource.                                                                       |
| Neutron Service Flavors                                     | flavors                   | Flavor specification for Neutron advanced services                                                                         |
| Network MTU                                                 | net-mtu                   | Provides MTU attribute for a network resource.                                                                             |
| Network IP Availability                                     | network-ip-availability   | Provides IP availability data for each network and subnet.                                                                 |
| Quota management support                                    | quotas                    | Expose functions for quotas management per tenant                                                                          |
| Provider Network                                            | provider                  | Expose mapping of virtual networks to physical networks                                                                    |
| Multi Provider Network                                      | multi-provider            | Expose mapping of virtual networks to multiple physical networks                                                           |
| Address scope                                               | address-scope             | Address scopes extension.                                                                                                  |
| Subnet service types                                        | subnet-service-types      | Provides ability to set the subnet service_types field                                                                     |
| Resource timestamps                                         | standard-attr-timestamp   | Adds created_at and updated_at fields to all Neutron resources that have Neutron standard attributes.                      |
| Neutron Service Type Management                             | service-type              | API for retrieving service providers for Neutron advanced services                                                         |
| Tag support for resources: subnet, subnetpool, port, router | tag-ext                   | Extends tag support to more L2 and L3 resources.                                                                           |
| Neutron Extra DHCP opts                                     | extra_dhcp_opt            | Extra options configuration for DHCP. For example PXE boot options to DHCP clients can be specified (e.g. tftp-server,     |
|                                                             |                           | server-ip-address, bootfile-name)                                                                                          |
| Resource revision numbers                                   | standard-attr-revisions   | This extension will display the revision number of neutron resources.                                                      |
| Pagination support                                          | pagination                | Extension that indicates that pagination is enabled.                                                                       |
| Sorting support                                             | sorting                   | Extension that indicates that sorting is enabled.                                                                          |
| security-group                                              | security-group            | The security groups extension.                                                                                             |
| RBAC Policies                                               | rbac-policies             | Allows creation and modification of policies that control tenant access to resources.                                      |
| standard-attr-description                                   | standard-attr-description | Extension to add descriptions to standard attributes                                                                       |
| Port Security                                               | port-security             | Provides port security                                                                                                     |
| Allowed Address Pairs                                       | allowed-address-pairs     | Provides allowed address pairs                                                                                             |
| project_id field enabled                                    | project-id                | Extension that indicates that project_id field is enabled.                                                                 |
+-------------------------------------------------------------+---------------------------+----------------------------------------------------------------------------------------------------------------------------+
[root@controller openstack]$ openstack network agent list
+--------------------------------------+--------------------+----------------------+-------------------+-------+-------+---------------------------+
| ID                                   | Agent Type         | Host                 | Availability Zone | Alive | State | Binary                    |
+--------------------------------------+--------------------+----------------------+-------------------+-------+-------+---------------------------+
| 146df99e-9b0c-4ec7-a206-d1695e2338bd | Linux bridge agent | compute5.lab.local   | None              | True  | UP    | neutron-linuxbridge-agent |
| 1eaf4f5c-07de-424d-be65-7b08f99c7a1c | Linux bridge agent | compute1.lab.local   | None              | True  | UP    | neutron-linuxbridge-agent |
| 1f7d55de-1483-4be5-907b-77a6708866b7 | DHCP agent         | controller.lab.local | nova              | True  | UP    | neutron-dhcp-agent        |
| 3b7e25ad-fb0d-4154-b845-fc93ea05b482 | Metadata agent     | controller.lab.local | None              | True  | UP    | neutron-metadata-agent    |
| 6896c867-c3ca-4006-9530-f6189ab3ef65 | Linux bridge agent | compute2.lab.local   | None              | True  | UP    | neutron-linuxbridge-agent |
| 9e2c2fb2-ff09-4097-b106-7857fc189ef6 | Linux bridge agent | controller.lab.local | None              | True  | UP    | neutron-linuxbridge-agent |
| d0a3ecee-facb-4069-8c7e-bdcaabc5dd67 | Linux bridge agent | compute4.lab.local   | None              | True  | UP    | neutron-linuxbridge-agent |
| d8b5f02a-9d48-45fa-b150-09213da6c091 | Linux bridge agent | compute3.lab.local   | None              | True  | UP    | neutron-linuxbridge-agent |
+--------------------------------------+--------------------+----------------------+-------------------+-------+-------+---------------------------+
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

3. Create a test instance

```
[root@controller openstack]$ . admin-openrc.sh
[root@controller openstack]$ openstack server create --flavor m1.nano --image cirros-0.3.4 \
>   --nic net-id=a275e07f-6e11-4ce1-92c1-40c32e764428 \
>   --security-group linux-default \
>   --key-name devops-key test-instance
+-------------------------------------+-----------------------------------------------------+
| Field                               | Value                                               |
+-------------------------------------+-----------------------------------------------------+
| OS-DCF:diskConfig                   | MANUAL                                              |
| OS-EXT-AZ:availability_zone         |                                                     |
| OS-EXT-SRV-ATTR:host                | None                                                |
| OS-EXT-SRV-ATTR:hypervisor_hostname | None                                                |
| OS-EXT-SRV-ATTR:instance_name       |                                                     |
| OS-EXT-STS:power_state              | NOSTATE                                             |
| OS-EXT-STS:task_state               | scheduling                                          |
| OS-EXT-STS:vm_state                 | building                                            |
| OS-SRV-USG:launched_at              | None                                                |
| OS-SRV-USG:terminated_at            | None                                                |
| accessIPv4                          |                                                     |
| accessIPv6                          |                                                     |
| addresses                           |                                                     |
| adminPass                           | N4Le973659Tr                                        |
| config_drive                        |                                                     |
| created                             | 2017-07-29T17:25:23Z                                |
| flavor                              | m1.nano (0)                                         |
| hostId                              |                                                     |
| id                                  | c08726b5-52c4-4c02-a092-e9e15a83343c                |
| image                               | cirros-0.3.4 (22a2efef-29fb-4221-a38a-695b56bfddf2) |
| key_name                            | devops-key                                          |
| name                                | test-instance                                       |
| progress                            | 0                                                   |
| project_id                          | 049bc1d6c4924390840e3d94ecdff939                    |
| properties                          |                                                     |
| security_groups                     | name='linux-default'                                |
| status                              | BUILD                                               |
| updated                             | 2017-07-29T17:25:23Z                                |
| user_id                             | a3c712f29e7e4101ba7b7eb1bbb57a28                    |
| volumes_attached                    |                                                     |
+-------------------------------------+-----------------------------------------------------+
[root@controller openstack]$ openstack server list
+--------------------------------------+---------------+--------+---------------------+--------------+
| ID                                   | Name          | Status | Networks            | Image Name   |
+--------------------------------------+---------------+--------+---------------------+--------------+
| c08726b5-52c4-4c02-a092-e9e15a83343c | test-instance | ACTIVE | provider=10.0.0.207 | cirros-0.3.4 |
+--------------------------------------+---------------+--------+---------------------+--------------+
[root@controller openstack]$ openstack console url show test-instance
+-------+---------------------------------------------------------------------------------+
| Field | Value                                                                           |
+-------+---------------------------------------------------------------------------------+
| type  | novnc                                                                           |
| url   | http://controller:6080/vnc_auto.html?token=9d469096-672f-464e-8fea-1040c644169c |
+-------+---------------------------------------------------------------------------------+
[root@controller openstack]$ ping -c 4 10.0.0.207
PING 10.0.0.207 (10.0.0.207) 56(84) bytes of data.
64 bytes from 10.0.0.207: icmp_seq=1 ttl=64 time=0.588 ms
64 bytes from 10.0.0.207: icmp_seq=2 ttl=64 time=0.298 ms
64 bytes from 10.0.0.207: icmp_seq=3 ttl=64 time=0.324 ms
64 bytes from 10.0.0.207: icmp_seq=4 ttl=64 time=0.416 ms

--- 10.0.0.207 ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3000ms
rtt min/avg/max/mdev = 0.298/0.406/0.588/0.115 ms
[root@controller openstack]$ ssh cirros@10.0.0.207 -i /home/devops/.ssh/id_rsa
$ hostname
test-instance
$ 
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


