
user_list:
    [{
    'name':'devops',
    'shell':'/bin/bash',
    'group':'devops',
    'ssh_public_key': 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC3UNn5BEixs1r4EcE2QyTMFgmg78uRmGHEuQEa208Nr9mXMMBCIUQkfkNDTIm7o/ndx2qxovqvkGe4dk/pgS2/qjRmlLUGbjo+E10IK6FnND9s4/DS894fT1oV8J2VGz0uEMJXMGt2Z2BRcULwccXqEIoxPseUOtvBR4TBgRIl0Hk5Ff1MyxIJUKdmyuraEkZApVAMBAgTdlzn2HVJIsoZJerwTyKbAbgC1ZhnPhXBRa+z+bPdQ13xzBKlsj6JUK96h7PuCe2Mc3ZUdSnY4l5jIsVwLsQ+b39mhlUu5rstryoGQaIvm3budwKokXeu8GguDPq/+oZn8fPPyFQ17XcR'
    }]

kernel:
  sysctl:
    fs.file-max: 737975
    kernel.sem: 250 32000 32 256
    net.core.somaxconn: 512
    net.ipv4.conf.all.accept_redirects: 1
    net.ipv4.conf.all.send_redirects: 1
    net.ipv4.ip_local_port_range: 1024 65535
    net.ipv4.tcp_fin_timeout: 15
    net.ipv4.tcp_timestamps: 1
    net.ipv4.tcp_window_scaling: 1
    net.ipv4.tcp_syncookies: 0
#    vm.swappiness: 0
#    vm.min_free_kbytes: 2000000

systems:
{% if grains['id'] == 'workstation1' %}
  dhcp:
    subnet: 10.0.0.0
    range: 10.0.0.0 10.0.0.16
    domain-name-servers:
      - 10.0.0.5
      - workstation1.mgmt
{% elif grains['id'] == 'workstation2' %}
  dhcp:
    subnet: 10.0.0.0
    range: 10.0.0.16 10.0.0.32
    domain-name-servers:
      - 10.0.0.6
      - workstation2.mgmt
{% elif grains['id'] == 'store1' %}
  network:
    bond0: 
      ipaddr: 10.0.0.41
      nic0: eth0
      nic1: eth1
    bond1: 
      ipaddr: 10.0.1.41
      nic0: eth2
      nic1: eth3
{% elif grains['id'] == 'store2' %}
  network:
    bond0:  
      ipaddr: 10.0.0.42
      nic0: eth0
      nic1: eth1
    bond1:  
      ipaddr: 10.0.1.42
      nic0: eth2
      nic1: eth3
{% elif grains['id'] == 'store3' %}
  network:
    bond0:
      ipaddr: 10.0.0.43
      nic0: eth0
      nic1: eth1
    bond1:
      ipaddr: 10.0.1.43
      nic0: eth2
      nic1: eth3
{% elif grains['id'] == 'store4' %}
  network:
    bond0:
      ipaddr: 10.0.0.44
      nic0: eth0
      nic1: eth1
    bond1:
      ipaddr: 10.0.1.44
      nic0: eth2
      nic1: eth3
{% elif grains['id'] == 'store5' %}
  network:
    bond0:
      ipaddr: 10.0.0.45
      nic0: eth0
      nic1: eth1
    bond1:
      ipaddr: 10.0.1.45
      nic0: eth2
      nic1: eth3
{% elif grains['id'] == 'store6' %}
  network:
    bond0:
      ipaddr: 10.0.0.46
      nic0: eth0
      nic1: eth1
    bond1:
      ipaddr: 10.0.1.46
      nic0: eth2
      nic1: eth3
{% elif grains['id'] == 'controller1' %}
  network:
    team0: 
      ipaddr: 10.0.0.11
      nic0: enp0s20f0
      nic1: enp0s20f1
      team_config: '{"runnner":{"name":"activebackup"}}'
    team1:
      ipaddr: 192.168.1.11
      nic0: enp0s20f2
      nic1: enp0s20f3
      team_config: '{"runnner":{"name":"activebackup"}}'
{% elif grains['id'] == 'network1' %}
  network:
    team0:
      ipaddr: 10.0.0.21
      nic0: enp0s20f0
      nic1: enp0s20f1
      team_config: '{"runnner":{"name":"activebackup"}}'
    team1:
      ipaddr: 10.0.1.21
      nic0: enp0s20f2
      nic1: enp0s20f3
      team_config: '{"runnner":{"name":"activebackup"}}'
{% elif grains['id'] == 'compute1' %}
  network:
    team0:
      ipaddr: 10.0.0.31
      nic0: enp0s20f0
      nic1: enp0s20f1
      team_config: '{"runnner":{"name":"activebackup"}}'
    team1:
      ipaddr: 10.0.1.31
      nic0: enp0s20f2
      nic1: enp0s20f3
      team_config: '{"runnner":{"name":"activebackup"}}'
{% elif grains['id'] == 'compute2' %}
  network:
    team0:
      ipaddr: 10.0.0.32
      nic0: enp0s20f0
      nic1: enp0s20f1
      team_config: '{"runnner":{"name":"activebackup"}}'
    team1:
      ipaddr: 10.0.1.32
      nic0: enp0s20f2
      nic1: enp0s20f3
      team_config: '{"runnner":{"name":"activebackup"}}'
{% elif grains['id'] == 'conn1' %}
  network:
    bond0:
      ipaddr: 10.0.0.51
      nic0: eth0
      nic1: eth1
    bond1:
      ipaddr: 10.0.1.51
      nic0: eth2
      nic1: eth3
{% elif grains['id'] == 'conn2' %}
  network:
    bond0:
      ipaddr: 10.0.0.52
      nic0: eth0
      nic1: eth1
    bond1:
      ipaddr: 10.0.1.52
      nic0: eth2
      nic1: eth3
{% elif grains['id'] == 'super' %}
  network:
    bond0:
      ipaddr: 10.0.0.61
      nic0: eth0
      nic1: eth1
{% endif %}

