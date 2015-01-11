
base-/etc/sysctl.d/99-salt.conf:
  file.managed:
    - name: /etc/sysctl.d/99-salt.conf

net.ipv6.conf.all.disable_ipv6:
  sysctl.present:
    - value: 1
 
net.ipv6.conf.default.disable_ipv6:
  sysctl.present:
    - value: 1
 
net.ipv6.conf.lo.disable_ipv6:
  sysctl.present:
    - value: 1
