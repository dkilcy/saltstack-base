
# Important - iptables is required for OpenStack 

iptables:
  service.dead:
    - name: iptables
    - enable: False

  file.managed:
    - name: /etc/modprobe.d/netfilter.conf
    - source: salt://iptables/files/netfilter.conf
    - user: root
    - group: root
    - mode: 644

