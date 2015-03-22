#### CentOS 6.5 Ethernet Bonding
Example:
* eth1/eth2 bonded to bond0

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
