
/etc/sysconfig/network-scripts/ifcfg-bond0:
  file.managed:
    - name: /etc/sysconfig/network-scripts/ifcfg-bond0
    - contents: |
        DEVICE=bond0
        BOOTPROTO=static
        IPADDR={{ salt['grains.get']('fqdn_ip4:0') }}
        NETMASK=255.255.255.0
        ONBOOT=yes
        USERCTL=no
        BONDING_OPTS="miimon=100 mode=4 lacp_rate=1 xmit_hash_policy=layer3+4"
        MTU=9000

{% set eth = 'enp0s20f' %}
{% for num in range(0,4,1) %}

/etc/sysconfig/network-scripts/ifcfg-{{ eth }}{{ num }}:
  file.managed:
    - name: /etc/sysconfig/network-scripts/ifcfg-{{ eth }}{{ num }}
    - contents: |
        DEVICE={{ eth }}{{ num }}
        NM_CONTROLLED=no
        ONBOOT=yes
        BOOTPROTO=none
        MASTER=bond0
        SLAVE=yes
        USERCTL=no

{% endfor %}

