#

base:
  '*':
    - local
#    - yumrepo
    - selinux
    - ipv6
    - ssd
    - cpupower
#    - ntp
#    - users
#    - vim

  'ring*':
    - iptables
