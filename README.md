## Salt tools for bare-metal provisioning

Other projects that use this repository:
- [kilo-saltstack](https://github.com/dkilcy/kilo-saltstack) - OpenStack 3+ node architecture on CentOS 7
- [juno-saltstack](https://github.com/dkilcy/juno-saltstack) - OpenStack 3+ node architecture on CentOS 7

### Introduction

Use SaltStack (Salt) in conjunction with PXE server/kickstart to install and provision multiple bare-metal machines running CentOS.

In this project, the Salt masters are installed manually, and the minions are installed via PXE/kickstart.  

Bare-metal machines take on one of two roles:
- Salt master 
- Salt minion 

### Lab Infrastructure

- 3 [MintBox2](http://www.fit-pc.com/web/products/mintbox/mintbox-2/)
- 10 [Supermicro SYS-5108A](http://www.newegg.com/Product/Product.aspx?Item=N82E16816101837)
- 2 TP-Link TL-SG-3216 L2 Switches
- 2 TP-Link TL-SG-3424 L2 Switches
- 2 Dell Powerconnect 6224 L3 Switches

The MintBox2 machines are the Salt masters running CentOS 7 with the MATE desktop.  The Supermicros are the Salt minions running CentOS 6 or 7.

Network infrastructure is described [here](notes/centos-7-manual.md)

### Lab Setup

1. [Install CentOS 7 on MintBox2](notes/centos-7-manual.md#manual-install-from-media)
2. [Install Salt Master on MintBox2]() 
3. [Setup PXE Server on MintBox2]()
4. [Setup Supermicros (or other MintBox2) via PXE Server]()
5. [Setup Salt Minions on Supermicros]()


6. Configure and start the Salt minion on the workstation machine as **root** user.

 ```bash
hostname -s > /etc/salt/minion_id

systemctl start salt-minion.service
systemctl enable salt-minion.service
```

7. Add the minion to the master as root user.

 ```bash
[root@workstation1 minion.d]# salt-key -L
Accepted Keys:
Unaccepted Keys:
workstation1
Rejected Keys:
[root@workstation1 minion.d]# salt-key -A 
The following keys are going to be accepted:
Unaccepted Keys:
workstation1
Proceed? [n/Y]  
Key for minion workstation1 accepted.
```

6. Test the installation as root user.

 ```bash
salt '*' test.ping
```

7. Update the local minion with the pillar data as root user.

 ```bash
salt '*' saltutil.refresh_pillar
```

8. Set the grains for the Salt master:

 ```bash
salt 'workstation*' grains.setvals "{'saltstack-base:{'role':'master'}}"
```

### Post-Installation tasks

TODO: Put the following into a state file for workstation

1. Setup ntpd on the workstation to be an NTP time server

 ```bash
yum install ntp
systemctl start ntpd.service
systemctl enable ntpd.service
```

2. Verify the NTP installation

 ```bash
[root@workstation1 ~]# ntpq -p
     remote           refid      st t when poll reach   delay   offset  jitter
==============================================================================
-y.ns.gin.ntt.ne 198.64.6.114     2 u  465 1024  375   38.859  -14.201   8.438
*ntp.your.org    .CDMA.           1 u  853 1024  377   29.042    1.957   4.626
+www.linas.org   129.250.35.250   3 u  470 1024  377   44.347    1.349   5.194
+ntp3.junkemailf 149.20.64.28     2 u  675 1024  337   78.504    4.305   3.001

[root@workstation1 ~]# ntpq -c assoc

ind assid status  conf reach auth condition  last_event cnt
===========================================================
  1  3548  933a   yes   yes  none   outlyer    sys_peer  3
  2  3549  963a   yes   yes  none  sys.peer    sys_peer  3
  3  3550  9424   yes   yes  none candidate   reachable  2
  4  3551  9424   yes   yes  none candidate   reachable  2
[root@workstation1 ~]# 
```

3. Install the reposync.sh tool as **root** user.

 ```bash
cp /home/devops/git/saltstack-base/states/yumrepo/files/reposync.sh /usr/local/bin/
```

4. Setup apache to host the yum repository 
 
 ```bash
yum install httpd
systemctl start httpd.service
systemctl enable httpd.service
```

5. Set one of the masters to update the repository at 4am every day via cron

6. Install DHCP server   

 ```bash
yum install dhcp
mv /etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd.conf.`date +%s`
cp /home/devops/git/saltstack-base/dhcp/files/dhcpd.conf /etc/dhcp/
systemctl start dhcpd.service
systemctl enable dhcpd.service
```

7. Assign the master role:

 ```bash
# salt 'workstation2' grains.setvals "{'saltstack-base':{'role':'master'}}"
```

8. Setup PXE server 

 ```bash
**TODO**
```

### Recommended 

1. Test and burn-in the hardware using Prime95

Download [Prime95](http://www.mersenne.org/ftp_root/gimps/p95v285.linux64.tar.gz)

### Setup Salt Minions

1. Install OS from PXE server
2. **From the Salt master:** Accept the key and set the role grain for the minion: 

 ```bash
salt-key -L
salt '*' test.ping
salt '*' saltutil.refresh_pillar
salt 'store*' grains.setvals "{'saltstack-base':{'role':'minion'}}"
```
 
 
3. TODO: setup networking, just for storage nodes
```bash
salt '<minion_id>' state.sls iptables saltenv=base
salt '<minion_id>' state.sls selinux saltenv=base
salt '<minion_id>' state.sls network.bond saltenv=base
```
From console: `reboot`

4. TODO: setup networking for OpenStack 
```
salt 'controller*' state.sls network.team
salt 'network*' state.sls network.team
salt 'compute*' state.sls network.team
```
From console: `systemctl restart network.service`

```bash
salt '<minion_id'> state.highstate
```

#### References


 
