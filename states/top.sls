
base:

  'G@saltstack-base:master':
    - local
    - selinux
    - iptables
    - ipv6
    - ssd
{% if grains['os_family'] == 'RedHat' and grains['osmajorrelease'] == '7' %}
    #- cpupower
{% elif grains['os_family'] == 'RedHat' and grains['osmajorrelease'] == '6' %}
    #- cpuspeed
{% endif %}
    - vim

  'G@saltstack-base:minion':
    - local
    - selinux
    - yumrepo
    - ipv6
    - ssd
{% if grains['os_family'] == 'RedHat' and grains['osmajorrelease'] == '7' %}
    - cpupower
{% elif grains['os_family'] == 'RedHat' and grains['osmajorrelease'] == '6' %}
    - cpuspeed
{% endif %}
    - ntp
    - users
    - vim
# NOTE: iptables is required for juno-saltstack
#    - iptables
