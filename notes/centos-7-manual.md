
### Install CentOS 7 (Manual Install)

#### Overview

1. Install the CentOS 7 Operating System
2. Update the OS and install the EPEL
3. Disable SELinux and iptables
4. Install MATE Desktop
5. Setup devops user to sudo without a password
6. Setup NTP Server
7. Verify the changes

#### Install CentOS 7

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
25. Login as **devops** user.  Open a terminal window and `sudo su -` to root.

#### Update the OS and install the EPEL 

 ```bash
yum update
yum install epel-release
```

#### Disable SELinux and iptables

 ```bash
sed -i "s/SELINUX=enforcing/SELINUX=disabled/g" /etc/selinux/config
systemctl stop iptables.service
systemctl disable iptables.service
```   

Reboot to implement the change

#### Install MATE Desktop

 ```bash
yum groupinstall "MATE Desktop"
```

#### Setup devops user to sudo without password

Using `visudo` allow devops user to sudo without password.  
Add `devops ALL=(ALL) NOPASSWD: ALL` to the end of the file.

#### Setup NTP Server

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

#### Verify the changes

1. Reboot: `reboot`
2. Log back in using MATE as **devops** user. Open a terminal window.
2. Verify that SELinux and iptables are disabled.

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

#### Recommended 

1. Test and burn-in the hardware using Prime95

Download [Prime95](http://www.mersenne.org/ftp_root/gimps/p95v285.linux64.tar.gz)

