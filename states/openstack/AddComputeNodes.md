
## Add Compute Nodes


1. From the controller, add the compute service to the node

```
salt 'compute2' state.sls  openstack.nova.compute
```

2. Verify the changes

```
[root@controller ~]$  openstack hypervisor list
+----+---------------------+-----------------+-----------+-------+
| ID | Hypervisor Hostname | Hypervisor Type | Host IP   | State |
+----+---------------------+-----------------+-----------+-------+
|  1 | compute1.lab.local  | QEMU            | 10.0.0.31 | up    |
|  2 | compute2.lab.local  | QEMU            | 10.0.0.32 | up    |
+----+---------------------+-----------------+-----------+-------+
[root@controller ~]$ openstack compute service list
+----+------------------+----------------------+----------+---------+-------+----------------------------+
| ID | Binary           | Host                 | Zone     | Status  | State | Updated At                 |
+----+------------------+----------------------+----------+---------+-------+----------------------------+
|  3 | nova-consoleauth | controller.lab.local | internal | enabled | up    | 2017-07-28T01:19:56.000000 |
|  4 | nova-scheduler   | controller.lab.local | internal | enabled | up    | 2017-07-28T01:20:04.000000 |
|  5 | nova-conductor   | controller.lab.local | internal | enabled | up    | 2017-07-28T01:20:05.000000 |
|  6 | nova-compute     | compute1.lab.local   | nova     | enabled | up    | 2017-07-28T01:20:06.000000 |
|  7 | nova-compute     | compute2.lab.local   | nova     | enabled | up    | 2017-07-28T01:20:00.000000 |
+----+------------------+----------------------+----------+---------+-------+----------------------------+
[root@controller ~]$ 
```

3. From the controller, add the network service to the node

```
salt 'compute2' state.sls  openstack.neutron.compute
```

4. Verify the changes

```
[root@controller ~]$ openstack network agent list
+--------------------------------------+--------------------+----------------------+-------------------+-------+-------+---------------------------+
| ID                                   | Agent Type         | Host                 | Availability Zone | Alive | State | Binary                    |
+--------------------------------------+--------------------+----------------------+-------------------+-------+-------+---------------------------+
| 3262b218-c296-4584-a100-4dafd125797c | Linux bridge agent | compute2.lab.local   | None              | True  | UP    | neutron-linuxbridge-agent |
| 4ef9648a-14e4-4e7b-b250-42d3545017c3 | Metadata agent     | controller.lab.local | None              | True  | UP    | neutron-metadata-agent    |
| 52fa7337-d6af-44c5-a61e-374a3e35fc6f | Linux bridge agent | compute1.lab.local   | None              | True  | UP    | neutron-linuxbridge-agent |
| 726787a4-7332-4cf5-91c8-6477415a5d73 | Linux bridge agent | controller.lab.local | None              | True  | UP    | neutron-linuxbridge-agent |
| 9ab9a94a-f7a6-46f9-ad4a-52bf0efd704d | DHCP agent         | controller.lab.local | nova              | True  | UP    | neutron-dhcp-agent        |
+--------------------------------------+--------------------+----------------------+-------------------+-------+-------+---------------------------+
```

