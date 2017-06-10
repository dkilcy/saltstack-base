
user_list:
    [{
    'name':'devops',
    'shell':'/bin/bash',
    'group':'devops',
    'ssh_public_key': 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDOBs6w4xiEvecrxC9a+F2tctZme25mq5VJQT858CLzSb16SMsJwGn3I5h2yY/6TzUC12NyQZgRoDvvkhOfu4Tz5RHEEsKbgGPB+IP55YbBlXuBZJ30fbReQZoIFkG0ESrXTWv0pD3gTItutFIaezo7KIaCjoeAo08gT9sHah4BeX4uDdHDmFUtwUP7ct3hA2zSwDeFIyvatWkkyqjR05KAeg6LqlGte9uLTZrCm7z+pUUkwd++k88JknFB8BaUMRHqJJu7jg5sTg1HvAhhmqlLA9DBp+7edwfIeylSppOc7keLz6kFFdhzGIHmiTG/jevZ0WI20d4gMJLkQQov1REf devops@ws2.lab.local'
    },
    {
    'name':'scality',
    'shell':'/bin/bash',
    'group':'scality',
    'ssh_public_key': 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCsfp91HukIlK5SoQ+Zgs+KC5pSy71yiQPNdAQBJdmX79bgbHnBWi2A/mK8+SzDN8q41CRh6g0MLn7H975x0N7XTm3DiaovK2KYpIpXBuVp3CQMxXtQWv74uN8zKMxA5Dbmmlb7QsnN92i2LqfFoUMkVJu2Y95dh85Odjvo7Cvg95xVxkENwbmF3Xaswa/ZqA4WnOmYOiGvcqJNmVyCcUByAJ9ousJI8di6eq4lVL6WFLCwPGNi/ILHh1ZHagnhdJnN5efsyA0VGT4mUhFh6zYw4sBxfKk54Un95JEpSMvoKttsi+ZUiW8rDcaTQSagmTPEm4WNHrnb64XiQ69Yk7QR scality@ws2.lab.local'
    }]

kernel:
  sysctl:
    fs.file-max: 737975
    kernel.sem: 250 32000 32 256
#    net.core.somaxconn: 512
#    net.ipv4.conf.all.accept_redirects: 1
#    net.ipv4.conf.all.send_redirects: 1
    net.ipv4.ip_local_port_range: 20001 65535
    net.ipv4.tcp_fin_timeout: 15
    net.ipv4.tcp_timestamps: 1
    net.ipv4.tcp_window_scaling: 1
    net.ipv4.tcp_syncookies: 0
    vm.swappiness: 1
#    vm.min_free_kbytes: 2000000

systems:
{% if grains['id'] == 'ws1' %}
  dhcp:
    subnet: 10.0.0.0
    range: 10.0.0.0 10.0.0.12
    domain-name-servers:
      - 10.0.0.5
      - ws1.lab.local
{% elif grains['id'] == 'ws2' %}
  dhcp:
    subnet: 10.0.0.0
    range: 10.0.0.13 10.0.0.24
    domain-name-servers:
      - 10.0.0.6
      - ws2.lab.local
{% endif %}

