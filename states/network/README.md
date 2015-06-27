

## Network

1. [General](#general)
2. [CentOS 7 Teaming](#centos-7-teaming)
3. [CentOS 6 Bonding](#centos-6-bonding)
4. [References](#references)

### General

- Stats: `ss`
- Add default route `ip route add default via 192.168.1.1 dev enp5s0`
- IP: `ip addr`  `ip route`
- Show which process is using a port: `netstat -anp | grep 8775`  
- Set MTU to 9000: `ip link set enp0s20f2 mtu 9000`
- Disable NetworkManager
  ```bash
  service NetworkManager stop
  chkconfig NetworkManager off
  service network start
  chkconfig network on
  ```

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

### CentOS 6 Bonding

Bonding runs in user and kernel space.

#### Example: eth1/eth2 bonded to bond0

Create /etc/modprobe.d/bonding.conf to load the kernel module
```
alias bond0 bonding
```

Create /etc/sysconfig/network-scripts/ifcfg-bond0
```
DEVICE=bond0
BOOTPROTO=static
IPADDR=10.0.1.21
NETMASK=255.255.255.0
ONBOOT=yes
USERCTL=no
BONDING_OPTS="mode=1 miimon=100"
```

Edit /etc/sysconfig/network-scripts/ifcfg-eth1
```
DEVICE=eth1
HWADDR="00:25:90:F1:0D:A8"
TYPE=Ethernet
UUID=d4df31a8-0549-4568-953c-2a9db136d53c
ONBOOT=yes
NM_CONTROLLED=no
BOOTPROTO=none
USERCTL=no
MASTER=bond0
SLAVE=yes
```

Edit /etc/sysconfig/network-scripts/ifcfg-eth2
```
DEVICE=eth2
HWADDR="00:25:90:F1:0D:A9"
TYPE=Ethernet
UUID="0334725a-f9bd-4e89-a2f5-bf1590547af3"
ONBOOT=yes
NM_CONTROLLED=no
BOOTPROTO=none
USERCTL=no
MASTER=bond0
SLAVE=yes
```

Restart networking
```
$ service network restart
```

Check IP info
```
$ route
Kernel IP routing table
Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
10.0.0.0        *               255.255.255.0   U     0      0        0 eth0
10.0.1.0        *               255.255.255.0   U     0      0        0 bond0
link-local      *               255.255.0.0     U     1006   0        0 eth0
link-local      *               255.255.0.0     U     1014   0        0 bond0

$ ifconfig -a
bond0     Link encap:Ethernet  HWaddr 00:25:90:F1:0D:A8  
          inet addr:10.0.1.21  Bcast:10.0.1.255  Mask:255.255.255.0
          UP BROADCAST RUNNING MASTER MULTICAST  MTU:1500  Metric:1
          RX packets:228450 errors:0 dropped:0 overruns:0 frame:0
          TX packets:2 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0 
          RX bytes:124810606 (119.0 MiB)  TX bytes:84 (84.0 b)
...
eth1      Link encap:Ethernet  HWaddr 00:25:90:F1:0D:A8  
          UP BROADCAST RUNNING SLAVE MULTICAST  MTU:1500  Metric:1
          RX packets:109939 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:62007840 (59.1 MiB)  TX bytes:0 (0.0 b)
          Memory:df360000-df380000 

eth2      Link encap:Ethernet  HWaddr 00:25:90:F1:0D:A8  
          UP BROADCAST RUNNING SLAVE MULTICAST  MTU:1500  Metric:1
          RX packets:118511 errors:0 dropped:0 overruns:0 frame:0
          TX packets:2 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:62802766 (59.8 MiB)  TX bytes:84 (84.0 b)
          Memory:df340000-df360000 
```

Check bonding driver
```
$ cat /proc/net/bonding/bond0 
Ethernet Channel Bonding Driver: v3.6.0 (September 26, 2009)

Bonding Mode: fault-tolerance (active-backup)
Primary Slave: None
Currently Active Slave: eth2
MII Status: up
MII Polling Interval (ms): 100
Up Delay (ms): 0
Down Delay (ms): 0

Slave Interface: eth1
MII Status: up
Speed: 1000 Mbps
Duplex: full
Link Failure Count: 0
Permanent HW addr: 00:25:90:f1:0d:a8
Slave queue ID: 0

Slave Interface: eth2
MII Status: up
Speed: 1000 Mbps
Duplex: full
Link Failure Count: 0
Permanent HW addr: 00:25:90:f1:0d:a9
Slave queue ID: 0
```

### References:
- [RHEL: Linux Bond / Team Multiple Network Interfaces (NIC) Into a Single Interface](http://www.cyberciti.biz/tips/linux-bond-or-team-multiple-network-interfaces-nic-into-single-interface.html)
- [CentOS Teaming with VLANS](http://techgnat.blogspot.com/2014/12/centos-teaming-with-vlans.html)
- [http://dak1n1.com/blog/7-performance-tuning-intel-10gbe](http://dak1n1.com/blog/7-performance-tuning-intel-10gbe)
