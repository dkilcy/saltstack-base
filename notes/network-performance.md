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

