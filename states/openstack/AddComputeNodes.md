
## Add Compute Nodes


1. From the controller, add the server to the cluster

```
salt 'compute2' state.sls  openstack.nova.compute
```

2. Confirm compute node is in the database

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

3. 
