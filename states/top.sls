
base:

  'G@saltstack-base:role:master':
    - local
    - selinux
    - iptables
    - network
    - kernel
    - packages
    - ssd
{% if grains['os_family'] == 'RedHat' and grains['osmajorrelease'] == '7' %}
    - cpupower
    - chrony.server
{% elif grains['os_family'] == 'RedHat' and grains['osmajorrelease'] == '6' %}
    - cpuspeed
    - ntp.server
{% endif %}
    - users
    - irqbalance

  'G@saltstack-base:role:minion':
    - local
    - selinux
    - iptables
    - network
    - network.bond
    - kernel
    - yumrepo
    - packages
    - ssd
{% if grains['os_family'] == 'RedHat' and grains['osmajorrelease'] == '7' %}
    - cpupower
    - chrony.client
{% elif grains['os_family'] == 'RedHat' and grains['osmajorrelease'] == '6' %}
    - cpuspeed
    - ntp.client
{% endif %}
    - users
    - irqbalance
