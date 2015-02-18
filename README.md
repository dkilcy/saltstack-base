### saltstack-base

This is a work-in-progress.

This repository is for configuring a workstation for bootstrap other machines in my lab.

This is a base environment for my other projects:
- [juno-saltstack](https://github.com/dkilcy/juno-saltstack)

Lab Configuration:

| Hostname | Public IP | Lab IP |
|----------|-----------|--------|
| workstation1 | 192.168.1.5 | 10.0.0.5 |
| workstation2 | 192.168.1.6 | 10.0.0.6 |

### Initial Setup

1. Install CentOS 7 from the media image.  Create a user devops as an administrator.
2. Add the EPEL and update: 

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

1. Configure GitHub and pull projects as devops user

 ```bash
yum install git
mkdir ~/git ; cd ~/git
git clone https://github.com/dkilcy/saltstack-base.git
git clone https://github.com/dkilcy/juno-saltstack.git
```

2. Install the Salt master and minion on the workstation 

 ```bash
yum install salt-master salt-minion
salt --version
```
3. Point Salt to the development environment

 ```bash
ln -sf /home/devops/git/saltstack-base /srv/salt/base
```
4. Create a file called /etc/salt/master.d/99-salt-envs.conf

 ```bash
file_roots:
  base:
    - /srv/salt/base/states
pillar_roots:
  base:
    - /srv/salt/base/pillar
```
5. Start the Salt master and minion on the workstation machine

 ```bash 
systemctl start salt-master.service
systemctl enable salt-master.service
```
6. Test the installation

 ```bash
salt '*' test.ping
```
7. Update all the minions with the pillar data

 ```bash
salt '*' saltutil.refresh_pillar
salt '*' saltutil.sync_all
```

### Post-Installation tasks

TODO: Put the following into a state file for workstation

1. Setup NTPD or the workstation to be an NTP time server

 ```bash
systemctl start ntpd.service
systemctl enable ntpd.service
ntpq -p
```
1. Set the hosts file as root

 ```bash
mv /etc/hosts /etc/hosts.`date +%s`
cp /home/devops/git/juno-saltstack/files/workstation/etc/hosts /etc/hosts
```   

2. Setup apache  
 
 ```bash
yum install -y httpd
systemctl start httpd.service
systemctl enable httpd.service
```
4. Setup DHCP server   

 ```bash
yum install -y dhcp
mv /etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd.conf.`date +%s`
cp /home/devops/git/juno-saltstack/files/workstation/etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd.conf
systemctl start dhcpd.service
systemctl enable dhcpd.service
```
5. Create the repository mirror  

 ```bash
cp /home/devops/git/saltstack-base/states/yumrepo/files/reposync.sh
reposync.sh

yum clean all
yum update

yum grouplist
```

6. Remove the EPEL repository installed earlier and use the local mirror

The workstation setup is complete.

#### References

 
