
base:

  'G@saltstack-base:role:master':
    - local
    - selinux
    - iptables
    - ssd
{% if grains['os_family'] == 'RedHat' and grains['osmajorrelease'] == '7' %}
    #- cpupower
{% elif grains['os_family'] == 'RedHat' and grains['osmajorrelease'] == '6' %}
    #- cpuspeed
{% endif %}
    - vim

  'G@saltstack-base:role:minion':
    - local
    - selinux
    - yumrepo
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
