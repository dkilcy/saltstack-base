
packages:
  recommended:
    - bc
    - bind-utils
    - bonnie++
    - createrepo
    - curl
    - dstat
    - e2fsprogs
    - fio
    - gdisk
    - hdparm
    - htop
    - iotop
    - irqbalance
#    - kernel-tools
    - lshw
    - lsof
    - lvm2
    - net-snmp
    - net-snmp-perl
    - net-snmp-utils
    - ngrep
    - nmap
    - ntp
    - numactl
    - openldap-clients
    - openssh-clients
    - parted
    - perf
    - pciutils
    - rsync
#    - s3cmd
    - screen
    - sdparm
    - smartmontools
    - strace
    - sysstat
    - tcpdump
    - telnet
    - traceroute
    - tuned
    - unzip
#    - util-linux-ng
    - vim-enhanced
    - wget
    - wireshark
    - yum-utils
    - zip

{% if grains['os_family'] == 'RedHat' and grains['osmajorrelease'] == '7' %}
    - iperf3
{% elif grains['os_family'] == 'RedHat' and grains['osmajorrelease'] == '6' %}
    - iperf
    - pdsh
{% endif %}

