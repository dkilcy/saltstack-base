
### Install CentOS 7 (Manual Install)

### Overview

### Install CentOS 7

1. Boot from media
2. Keyboard and Language 
2. Under Software, click Software Selection.  The Software Selection page appears.
3. Select Server with GUI, click Done in the upper-left.
4. Under System, click Installation Destination.  The Installer Destiation page appeares. 
5. Under Partitioning, select **I will configure partitioning**, click **Done**
6. The Manual Partitioning page appears.
7. Under **New mout points will use the following partitioning scheme** select **Standard Partition**
8. Click +.  The **Add a new mount point** dialog will appear.
9. For Mount Point, select `/boot`. For Desired Capacity enter `512`.  Click **Add Mount Point**
10. Click +. The **Add a new mount point** dialog will appear.
11. For Mount Point, select `swap`.  For Desired Capacity enter `4096`.  Click **Add Mount Point**
12. Click +. The **Add a new mount point** dialog will appear.
13. For Mount Point, select `/`.  Do not enter anything into Desired Capacity.  .  Click **Add Mount Point**
14. Click Done in the upper left.  The Summary of Changes window appears.  Click **Accept Changes**
15. Under System, click **Network & Hostname**
16. Select ethernet interface.  Click slider in upper-right On.  Click **Configure** in lower-right
17. Click General Tab.  Select **Automatically connect to this network when it is available**
18. Click IPv4 Tab.  Configure the network information.  Set the hostname to **workstation1**
19. Click Begin Installation
20. Add **devops** user
21. Set root password
22. Reboot
23. Accept the License agreement
24. Reboot 

### Post-Install Setup

Boot into the OS and login as **devops** user.  Open a terminal window and `sudo su -` to root.

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

Reboot to implement the change: `reboot`

6. Log back in using MATE as **devops** user. Open a terminal window.
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


