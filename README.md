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
2. [Setup Salt Master and Minion on MintBox2](notes/setup-salt.md) 
2. [Setup Git and saltstack-base repository on MintBox2](notes/saltstack-base-setup.md)
3. [Setup PXE Server on MintBox2](notes/pxe-server-setup.md)
4. [Install Supermicros (or other MintBox2) via PXE Server](notes/pxe-install.md)

### Assigning Roles to Machines


### Scratch

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


 
