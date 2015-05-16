
### selinux

1. Disable SELinux:

 ```bash
sed -i "s/SELINUX=enforcing/SELINUX=disabled/g" /etc/selinux/config
```   

2. Reboot to implement the change: `reboot now` 

3. Verify that SELinux and iptables are disabled.
 ```bash
[root@workstation1 ~]# sestatus
SELinux status:                 disabled
[root@workstation1 ~]# 
```
