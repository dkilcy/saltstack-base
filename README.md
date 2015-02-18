## saltstack-base

### Introduction

Difficulty: Intermediate

This repository is for documenting my home lab environment.  It describes all of the steps to configure a set of bare-metal servers which act in a manager role to administer the rest of the physical servers in the lab.  It at the 'unboxing' state, and assumes no other infrastructure than an existing network with Internet access.

These systems run CentOS 7 and SaltStack (Salt) for configuration management.   They act in the Salt master role, with the rest of the servers in the lab acting in the minion role.   This repository does not deal with anything other than the servers to be configured as Salt masters.

Specifications for the Salt masters:
- Intel i5 x86 quad-core
- 8GB memory
- 1x 300GB SSD
- 2x 1Gb NICs

| Hostname | Public IP (.pub) | Lab IP (.mgmt) |
|----------|-----------|--------|
| workstation1 | 192.168.1.5 | 10.0.0.5 |
| workstation2 | 192.168.1.6 | 10.0.0.6 |

Other projects that use this repository:
- [juno-saltstack](https://github.com/dkilcy/juno-saltstack) - Openstack 3+ node architecture on CentOS 7

- Go over a quick SaltStack tutorial [HERE]()
- Go over a 

### Install CentOS 7

1. Install CentOS 7 from media image.  These steps are documented [HERE]()
 TODO: Create a user devops as an administrator.
 
### Setup Base Environment 

Boot into the OS.

1. Add the EPEL and update: 

 ```bash
yum install -y http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm
yum update -y
yum upgrade -y
```

3. Install MATE Desktop: `yum groupinstall "MATE Desktop"`
4. Reboot and log back in using MATE
5. Using `visudo` allow devops user to sudo without password: `devops ALL=(ALL) NOPASSWD: ALL`
6. Set security policies as root:

 ```bash
sed -i "s/SELINUX=enforcing/SELINUX=disabled/g" /etc/selinux/config
systemctl stop iptables.service
systemctl disable iptables.service
```   

7. Reboot to implement the change and log back in. 
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
 [root@workstation1 minion.d]# ntpq -p
     remote           refid      st t when poll reach   delay   offset  jitter
==============================================================================
xy.ns.gin.ntt.ne 64.113.32.5      2 u    1   64    1   38.966  -17.327   0.921
*ntp.your.org    .CDMA.           1 u    2   64    1   28.120   -0.308   8.118
 www.linas.org   129.250.35.250   3 u    1   64    1   46.393   -3.929   2.743
 ntp3.junkemailf 149.20.64.28     2 u    2   64    1  106.421    2.786   0.000
[root@workstation1 minion.d]#
```

5. Create the repository mirror as root user.

 ```bash
cp /home/devops/git/saltstack-base/states/yumrepo/files/reposync.sh ~
cd ~
./reposync.sh

yum clean all
yum update

yum grouplist
```

6. Setup apache to host the repository 
 
 ```bash
yum install httpd
systemctl start httpd.service
systemctl enable httpd.service
```

6. Remove the EPEL repository installed earlier and use the local mirror

 ```bash
 yum remove epel
 ```

1. Update yum

3. Install DHCP server   

 ```bash
yum install dhcp
#mv /etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd.conf.`date +%s`
#cp /home/devops/git/juno-saltstack/files/workstation/etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd.conf
systemctl start dhcpd.service
systemctl enable dhcpd.service
```

The workstation setup is complete.

### Recommended 

1. Test and burn-in the hardware using Prime95

#### References

 
