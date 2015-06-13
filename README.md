## Salt tools for bare-metal provisioning

Other projects that use this repository:
- [juno-saltstack](https://github.com/dkilcy/juno-saltstack) - OpenStack 3+ node architecture on CentOS 7

### Introduction

Use SaltStack (Salt) in conjunction with Kickstart to install and provision multiple bare-metal machines running CentOS 7.

In this project, the Salt masters are installed manually, and the minions are installed via Kickstart.  
You can read on how to create Kickstart files [here](notes/kickstart/README.md)

- TODO: Go over a quick SaltStack tutorial [HERE]() 

The reference system for the Salt masters for testing is described in the next section. 

Reference Architecture:

Bare-metal machines take on one of two roles:
- Salt masters
- Salt minions

#### Salt master:
- [MintBox 2](http://www.amazon.com/MintBox-IPC-D2x2-C3337NL-H500-WB-XLM-FM4U-BMint-2-Desktop/dp/B00EONR674) 
- Intel Core i5-3337U @ 1.8 GHz
- 8GB DDR3 1600 memory
- 1x Intel S3500 300GB SSD
- 2x 1Gb NICs
- CentOS 7 with MATE Desktop

| Hostname | Public IP (.pub) | Lab IP (.mgmt) |
|----------|-----------|--------|
| workstation1 | 192.168.1.5 | 10.0.0.5 |
| workstation2 | 192.168.1.6 | 10.0.0.6 |
| workstation3 | 192.168.1.6 | 10.0.0.7 |

### Setup Salt Master

### Install CentOS 7

1. Install CentOS 7 from a media image.  These steps are documented [HERE](notes/centos-7-manual.md#manual-install-from-media)  

Make sure the user **devops** is created with the administrator role during installation.

### Setup Base Environment 

Boot into the OS and login as devops user.  Open a terminal window and `sudo su -` to root.

1. Update the OS and install the EPEL: 

 ```bash
yum update
yum install epel-release
```

2. Install MATE Desktop: `yum groupinstall "MATE Desktop"`
3. Using `visudo` allow devops user to sudo without password. Add `devops ALL=(ALL) NOPASSWD: ALL` to the end of the file.
4. Disable SELinux and iptables:

 ```bash
sed -i "s/SELINUX=enforcing/SELINUX=disabled/g" /etc/selinux/config
systemctl stop iptables.service
systemctl disable iptables.service
```   

5. Reboot to implement the change: `reboot`
6. Log back in using MATE as devops user. Open a terminal window.
6. Verify that SELinux and iptables are disabled.
 ```bash
[devops@workstation1 ~]$ sudo su -
Last login: Tue Feb 17 19:56:47 EST 2015 on pts/0
[root@workstation1 ~]# sestatus
SELinux status:                 disabled
[root@workstation1 ~]# systemctl status iptables.service
iptables.service - IPv4 firewall with iptables
   Loaded: loaded (/usr/lib/systemd/system/iptables.service; disabled)
   Active: inactive (dead)

[root@workstation1 ~]# 
```

### Setup Salt Master

1. Install git as root user: `yum install git`
2. Configure GitHub and pull projects as devops user

 ```bash
git config --global user.name "dkilcy"
git config --global user.email "david@kilcyconsulting.com"
 
mkdir ~/git ; cd ~/git
git clone https://github.com/dkilcy/saltstack-base.git
```

3. Install the Salt master and minion on the workstation as root user

 ```bash
yum install salt-master salt-minion
salt --version
mkdir /etc/salt/master.d
```

3. Create a YAML file to hold the customized Salt configuration.  As root user, execute `vi /etc/salt/master.d/99-salt-envs.conf` and add the following to the new file:

```yaml
file_roots:
  base:
    - /srv/salt/base/states
pillar_roots:
  base:
    - /srv/salt/base/pillar
```

4. Point Salt to the development environment as root user.

 ```bash
mkdir /srv/salt
ln -sf /home/devops/git/saltstack-base /srv/salt/base
```

5. Start the Salt master on the workstation machine as root user.

 ```bash 
systemctl start salt-master.service
systemctl enable salt-master.service
```
6. Configure and start the Salt minion on the workstation machine as root user.

 ```bash
hostname -s > /etc/salt/minion_id
echo "master: localhost" > /etc/salt/minion.d/99-salt.conf

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

3. Create the local mirror as root user.

 ```bash
cp /home/devops/git/saltstack-base/states/yumrepo/files/reposync.sh ~
cd ~
./reposync.sh

cp local.repo /etc/yum.repos.d/  TODO 
yum clean all
yum update
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
#mv /etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd.conf.`date +%s`
#cp /home/devops/git/juno-saltstack/files/workstation/etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd.conf
systemctl start dhcpd.service
systemctl enable dhcpd.service
```

The workstation setup is complete.

Assign roles:

```bash
# salt 'workstation2' grains.setvals "{'saltstack-base':{'role':'master'}}"
```

### Recommended 

1. Test and burn-in the hardware using Prime95

Download [Prime95](http://www.mersenne.org/ftp_root/gimps/p95v285.linux64.tar.gz)

### Setup Salt Minions

1. Install OS from PXE server
2. **From the Salt master:** Set the grains for the minion: 

```bash
salt '<minion_id>' grains.setvals "{'saltstack-base':{'role':'minion'}}"
```

#### References


 
