### CentOS 7 Teaming

Teaming replaces bonding in CentOS 7 release.

```
[root@ring-a6 ~]$ cat /etc/sysconfig/network-scripts/ifcfg-team0
DEVICE="team0"
DEVICETYPE="Team"
ONBOOT="yes"
BOOTPROTO="none"
IPADDR=10.0.0.66
NETMASK=255.255.255.0
TEAM_CONFIG='{"runnner":{"name":"roundrobin"}}'
MTU=9000
[root@ring-a6 ~]$ cat /etc/sysconfig/network-scripts/ifcfg-enp0s20f0
DEVICE="enp0s20f0"
DEVICETYPE="TeamPort"
ONBOOT="yes"
BOOTPROTO="none"
TEAM_MASTER="team0"
IPV6INIT="no"
[root@ring-a6 ~]$ cat /etc/sysconfig/network-scripts/ifcfg-enp0s20f1
DEVICE="enp0s20f1"
DEVICETYPE="TeamPort"
ONBOOT="yes"
BOOTPROTO="none"
TEAM_MASTER="team0"
IPV6INIT="no"
```

#### Verify setup
 
```
[root@ring-a6 ~]$  teamdctl team0 state view 
setup:
  runner: roundrobin
ports:
  enp0s20f0
    link watches:
      link summary: up
      instance[link_watch_0]:
        name: ethtool
        link: up
  enp0s20f1
    link watches:
      link summary: up
      instance[link_watch_0]:
        name: ethtool
        link: up
[root@ring-a6 ~]$  teamnl team0 ports
 3: enp0s20f1: up 0Mbit FD 
 2: enp0s20f0: up 0Mbit FD 
[root@ring-a6 ~]$ 
```

#### IP address information
```
[root@ring-a6 ~]$ ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN 
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
2: enp0s20f0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 9000 qdisc mq master team0 state UP qlen 1000
    link/ether 00:25:90:f1:0e:58 brd ff:ff:ff:ff:ff:ff
3: enp0s20f1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 9000 qdisc mq master team0 state UP qlen 1000
    link/ether 00:25:90:f1:0e:58 brd ff:ff:ff:ff:ff:ff
4: enp0s20f2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 9000 qdisc mq master team1 state UP qlen 1000
    link/ether 00:25:90:f1:0e:5a brd ff:ff:ff:ff:ff:ff
5: enp0s20f3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 9000 qdisc mq master team1 state UP qlen 1000
    link/ether 00:25:90:f1:0e:5a brd ff:ff:ff:ff:ff:ff
6: team0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 9000 qdisc noqueue state UP 
    link/ether 00:25:90:f1:0e:58 brd ff:ff:ff:ff:ff:ff
    inet 10.0.0.66/24 brd 10.0.0.255 scope global team0
       valid_lft forever preferred_lft forever
7: team1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 9000 qdisc noqueue state UP 
    link/ether 00:25:90:f1:0e:5a brd ff:ff:ff:ff:ff:ff
    inet 10.0.1.66/24 brd 10.0.1.255 scope global team1
       valid_lft forever preferred_lft forever
[root@ring-a6 ~]$ 

```

### References

[http://techgnat.blogspot.com/2014/12/centos-teaming-with-vlans.html]
