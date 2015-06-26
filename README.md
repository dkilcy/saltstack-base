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
- 2 [TP-Link TL-SG-3216 L2 Switches](http://www.tp-link.com/lk/products/details/cat-39_TL-SG3216.html)
- 2 [TP-Link TL-SG-3424 L2 Switches](http://www.tp-link.com/lk/products/details/cat-39_TL-SG3424.html)
- 2 [Dell Powerconnect 6224 L3 Switches](http://www.dell.com/us/business/p/powerconnect-6200-series/pd)

The MintBox2 machines are the Salt masters running CentOS 7 with the MATE desktop.  The Supermicros are the Salt minions running CentOS 6 or 7.

Network infrastructure is described [here](notes/network.md)

### Lab Setup

1. [Install CentOS 7 on MintBox2](notes/centos-7-manual.md)
2. [Setup Git and saltstack-base repository on MintBox2](notes/saltstack-base-setup.md)
2. [Install Salt Master on MintBox2](notes/install-salt-master) 
3. [Setup PXE Server on MintBox2](notes/pxe-server-setup)
4. [Setup Supermicros (or other MintBox2) via PXE Server](notes/pxe-install)
5. [Setup Salt Minions on Supermicros](notes/install-salt-minion)


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


 
