
kernel:
  sysctl:
    fs.file-max: 737975
    kernel.sem: 250 32000 32 256
    net.core.somaxconn: 512
#    net.core.netdev_max_backlog: 1000
#    net.core.optmem_max: 20480
#    net.core.rmem_default: 124928
#    net.core.rmem_max: 124928
#    net.core.wmem_default: 124928
#    net.core.wmem_max: 124928
    net.ipv4.conf.all.accept_redirects: 1
    net.ipv4.conf.all.send_redirects: 1
#    net.ipv4.conf.lo.arp_filter: 0
    ### increase IP port range to all for more concurrent connections
    net.ipv4.ip_local_port_range: 1024 65000
#    net.ipv4.net_congestion_control: cubic
#    net.ipv4.route.flush: 1
    net.ipv4.tcp_fin_timeout: 30
#    net.ipv4.tcp_low_latency: 0
    ### memory allocation min/pressure/max - buffer space
#    net.ipv4.tcp_mem: 366240 488320 732480
#    net.ipv4.tcp_moderate_rcvbuf: 1
#    net.ipv4.tcp_mtu_probing: 0
    ### memory allocation min/pressure/max - read buffer
#    net.ipv4.tcp_rmem: 4096 87380 4194304
#    net.ipv4.tcp_dsack: 1
#    net.ipv4.tcp_sack: 1
    net.ipv4.tcp_timestamps: 1
#    net.ipv4.tcp_window_scaling: 1
    ### memory allocation min/pressure/max - write buffer
#    net.ipv4.tcp_wmem: 4096 16384 4194304
    net.ipv4.tcp_syncookies: 0
    vm.swappiness: 0
    vm.min_free_kbytes: 2000000

