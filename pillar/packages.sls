
packages:
  recommended:
{% if grains['os_family'] == 'RedHat' and grains['osmajorrelease'] == '7' %}
    - iperf3
    - python2-pip
{% elif grains['os_family'] == 'RedHat' and grains['osmajorrelease'] == '6' %}
    - pdsh
{% endif %}
    - bc
    - bind-utils
    - bonnie++
    - createrepo
    - curl
    - dstat
    - e2fsprogs
    - fio
    - gcc
    - gdisk
    - hdparm
    - htop
    - iotop
    - iperf
    - irqbalance
#    - kernel-tools
    - libffi-devel
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
    - openssl-devel
    - parted
    - perf
    - pciutils
    - python-devel
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
