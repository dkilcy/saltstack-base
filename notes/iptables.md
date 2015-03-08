### Disable and unload iptables from the CentOS kernel

Systems still take a performance hit if iptables is stopped.  It needs to be unloaded from the kernel to see a boost in network performance

- CentOS 6: `service iptables stop ; chkconfig iptables off`
- CentOS 7: `systemctl stop iptables.service ; systemctl disable iptables.service`

##### Prevent the kernel modules from loading at boot.

```
[root@workstation1 ~]# cat /etc/modprobe.d/netfilter.conf 
alias ip_tables off
alias iptable off
alias iptable_nat off
alias iptable_filter off
alias x_tables off
alias nf_nat off
alias nf_conntrack_ipv4 off
alias nf_conntrack off

alias ip6_tables off
alias ip6table off
alias ip6table_nat off
alias ip6table_filter off
alias nf_nat_ipv6 off
alias nf_conntrack_ipv6 off
alias nf_conntrack off
```

Reboot the machine. Verify that iptables kernel modules are not loaded.

```
[root@workstation1 ~]# iptables -L
modprobe: ERROR: could not find module by name='off'
modprobe: ERROR: could not insert 'off': Function not implemented
iptables v1.4.21: can't initialize iptables table `filter': Table does not exist (do you need to insmod?)
Perhaps iptables or your kernel needs to be upgraded.

[root@workstation1 ~]# lsmod | grep ip
[root@workstation1 ~]# 
```

#### References
- [http://www.pc-freak.net/blog/resolving-nf_conntrack-table-full-dropping-packet-flood-message-in-dmesg-linux-kernel-log/](http://www.pc-freak.net/blog/resolving-nf_conntrack-table-full-dropping-packet-flood-message-in-dmesg-linux-kernel-log/)
- [http://nginx.com/blog/nginx-se-linux-changes-upgrading-rhel-6-6/](http://nginx.com/blog/nginx-se-linux-changes-upgrading-rhel-6-6/)
- [http://www.cyberciti.biz/faq/redhat-centos-disable-ipv6-networking/](http://www.cyberciti.biz/faq/redhat-centos-disable-ipv6-networking/)
