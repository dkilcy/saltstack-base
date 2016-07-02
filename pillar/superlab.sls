
user_list:
    [{
    'name':'devops',
    'shell':'/bin/bash',
    'group':'devops',
    'ssh_public_key': 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDOBs6w4xiEvecrxC9a+F2tctZme25mq5VJQT858CLzSb16SMsJwGn3I5h2yY/6TzUC12NyQZgRoDvvkhOfu4Tz5RHEEsKbgGPB+IP55YbBlXuBZJ30fbReQZoIFkG0ESrXTWv0pD3gTItutFIaezo7KIaCjoeAo08gT9sHah4BeX4uDdHDmFUtwUP7ct3hA2zSwDeFIyvatWkkyqjR05KAeg6LqlGte9uLTZrCm7z+pUUkwd++k88JknFB8BaUMRHqJJu7jg5sTg1HvAhhmqlLA9DBp+7edwfIeylSppOc7keLz6kFFdhzGIHmiTG/jevZ0WI20d4gMJLkQQov1REf devops@workstation2.pub'
    }]

kernel:
  sysctl:
    fs.file-max: 737975
    kernel.sem: 250 32000 32 256
    net.core.somaxconn: 512
    net.ipv4.conf.all.accept_redirects: 1
    net.ipv4.conf.all.send_redirects: 1
    net.ipv4.ip_local_port_range: 11001 65535
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
    team0: 
      ipaddr: 10.0.0.41
      nic0: enp0s20f0
      nic1: enp0s20f1
      team_config: '{"runnner":{"name":"lacp"}}'
    team1: 
      ipaddr: 10.0.1.41
      nic0: enp0s20f2
      nic1: enp0s20f3
      team_config: '{"runnner":{"name":"lacp"}}'
{% elif grains['id'] == 'store2' %}
  network:
    team0:  
      ipaddr: 10.0.0.42
      nic0: enp0s20f0
      nic1: enp0s20f1
      team_config: '{"runnner":{"name":"lacp"}}'
    team1:  
      ipaddr: 10.0.1.42
      nic0: enp0s20f2
      nic1: enp0s20f3
      team_config: '{"runnner":{"name":"lacp"}}'
{% elif grains['id'] == 'store3' %}
  network:
    team0:
      ipaddr: 10.0.0.43
      nic0: enp0s20f0
      nic1: enp0s20f1
      team_config: '{"runnner":{"name":"lacp"}}'
    team1:
      ipaddr: 10.0.1.43
      nic0: enp0s20f2
      nic1: enp0s20f3
      team_config: '{"runnner":{"name":"lacp"}}'
{% elif grains['id'] == 'store4' %}
  network:
    team0:
      ipaddr: 10.0.0.44
      nic0: enp0s20f0
      nic1: enp0s20f1
      team_config: '{"runnner":{"name":"lacp"}}'
    team1:
      ipaddr: 10.0.1.44
      nic0: enp0s20f2
      nic1: enp0s20f3
      team_config: '{"runnner":{"name":"lacp"}}'
{% elif grains['id'] == 'store5' %}
  network:
    team0:
      ipaddr: 10.0.0.45
      nic0: enp0s20f0
      nic1: enp0s20f1
      team_config: '{"runnner":{"name":"lacp"}}'
    team1:
      ipaddr: 10.0.1.45
      nic0: enp0s20f2
      nic1: enp0s20f3
      team_config: '{"runnner":{"name":"lacp"}}'
{% elif grains['id'] == 'store6' %}
  network:
    team0:
      ipaddr: 10.0.0.46
      nic0: enp0s20f0
      nic1: enp0s20f1
      team_config: '{"runnner":{"name":"lacp"}}'
    team1:
      ipaddr: 10.0.1.46
      nic0: enp0s20f2
      nic1: enp0s20f3
      team_config: '{"runnner":{"name":"lacp"}}'
{% elif grains['id'] == 'app1' %}
  network:
    team0: 
      ipaddr: 10.0.0.31
      nic0: enp0s20f0
      nic1: enp0s20f1
      team_config: '{"runnner":{"name":"lacp"}}'
    team1:
      ipaddr: 10.0.1.31
      nic0: enp0s20f2
      nic1: enp0s20f3
      team_config: '{"runnner":{"name":"lacp"}}'
{% elif grains['id'] == 'app2' %}
  network:
    team0:
      ipaddr: 10.0.0.32
      nic0: enp0s20f0
      nic1: enp0s20f1
      team_config: '{"runnner":{"name":"lacp"}}'
    team1:
      ipaddr: 10.0.1.32
      nic0: enp0s20f2
      nic1: enp0s20f3
      team_config: '{"runnner":{"name":"lacp"}}'
{% elif grains['id'] == 'app3' %}
  network:
    team0:
      ipaddr: 10.0.0.33
      nic0: enp0s20f0
      nic1: enp0s20f1
      team_config: '{"runnner":{"name":"lacp"}}'
    team1:
      ipaddr: 10.0.1.33
      nic0: enp0s20f2
      nic1: enp0s20f3
      team_config: '{"runnner":{"name":"lacp"}}'
{% elif grains['id'] == 'app4' %}
  network:
    team0:
      ipaddr: 10.0.0.34
      nic0: enp0s20f0
      nic1: enp0s20f1
      team_config: '{"runnner":{"name":"lacp"}}'
    team1:
      ipaddr: 10.0.1.34
      nic0: enp0s20f2
      nic1: enp0s20f3
      team_config: '{"runnner":{"name":"lacp"}}'
{% elif grains['id'] == 'app5' %}
  network:
    team0:
      ipaddr: 10.0.0.35
      nic0: enp0s20f0
      nic1: enp0s20f1
      team_config: '{"runnner":{"name":"lacp"}}'
    team1:
      ipaddr: 10.0.1.35
      nic0: enp0s20f2
      nic1: enp0s20f3
      team_config: '{"runnner":{"name":"lacp"}}'
{% endif %}


