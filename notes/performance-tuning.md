### Network Performance


```
[root@compute1 ~]$ sysctl -p /etc/sysctl.d/perf-test1.conf
net.core.rmem_max = 16777216
net.core.wmem_max = 16777216
net.ipv4.tcp_rmem = 4096 87380 174760
net.ipv4.tcp_wmem = 4096 16384 131072
net.ipv4.tcp_rmem = 4096 87380 16777216
net.ipv4.tcp_wmem = 4096 16384 16777216
net.core.netdev_max_backlog = 2500
net.ipv4.tcp_reordering = 127

ethtool -G enp0s20f2 rx 2048 tx 2048
ethtool -G enp0s20f3 rx 2048 tx 2048
```

```
sysctl -n net.core.rmem_max
sysctl -n net.core.wmem_max
sysctl -n net.ipv4.tcp_rmem
sysctl -n net.ipv4.tcp_wmem
sysctl -n net.ipv4.tcp_rmem
sysctl -n net.ipv4.tcp_wmem
sysctl -n net.core.netdev_max_backlog
sysctl -n net.ipv4.tcp_reordering

ethtool -g enp0s20f2
ethtool -g enp0s20f3

```

#### References

- [https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/7/html/Performance_Tuning_Guide/chap-Red_Hat_Enterprise_Linux-Performance_Tuning_Guide-Storage_and_File_Systems.html#sect-Red_Hat_Enterprise_Linux-Performance_Tuning_Guide-Considerations-Generic_tuning_considerations_for_file_systems](https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/7/html/Performance_Tuning_Guide/chap-Red_Hat_Enterprise_Linux-Performance_Tuning_Guide-Storage_and_File_Systems.html#sect-Red_Hat_Enterprise_Linux-Performance_Tuning_Guide-Considerations-Generic_tuning_considerations_for_file_systems)
- [https://communities.bmc.com/docs/DOC-10204](https://communities.bmc.com/docs/DOC-10204)
- [http://www.iozone.org/](http://www.iozone.org/)
  [http://blackbird.si/tips-for-optimizing-disk-performance-on-linux](http://blackbird.si/tips-for-optimizing-disk-performance-on-linux/)
- [http://dak1n1.com/blog/7-performance-tuning-intel-10gbe](http://dak1n1.com/blog/7-performance-tuning-intel-10gbe)
- [http://linuxmantra.com/2013/11/disk-read-ahead-in-linux.html](http://linuxmantra.com/2013/11/disk-read-ahead-in-linux.html)
- [https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/6/html/Performance_Tuning_Guide/ch04s02s03.html](https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/6/html/Performance_Tuning_Guide/ch04s02s03.html)
- 

