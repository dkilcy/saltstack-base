##############################################################################
# bond.sls
#
# @author dkilcy
#
##############################################################################

{% set id = grains['id'] %}

{% for num in range(0,4) %}

{% set bond = 'bond' + num|string %}

{% if pillar['systems']['network'][bond] is defined %}

{% set nic0 =   pillar['systems']['network'][bond]['nic0'] %}
{% set nic1 =   pillar['systems']['network'][bond]['nic1'] %}
{% set ipaddr = pillar['systems']['network'][bond]['ipaddr'] %}

{{ id }}_{{ nic0 }}:
  network.managed:
    - name: {{ nic0 }}
    - enabled: True
    - type: slave
    - master: {{ bond }}
    - order: 1

{{ id }}_{{ nic1 }}:
  network.managed:
    - name: {{ nic1 }}
    - enabled: True
    - type: slave
    - master: {{ bond }}
    - order: 2

{{ id }}_{{ bond }}:
  network.managed:
    - name: {{ bond }}
    - type: bond
    - ipaddr: {{ ipaddr }}
    - netmask: 255.255.255.0
    - mode: active-backup
    - proto: none 
    - slaves: {{ nic0 }} {{ nic1 }}
    - require:
      - network: {{ nic0 }}
      - network: {{ nic1 }}
    - miimon: 100
    - arp_interval: 250
    - downdelay: 200
    - lacp_rate: fast
    - max_bonds: 1
    - updelay: 0
    - use_carrier: on
    - xmit_hash_policy: layer2
    - mtu: 9000
    - autoneg: off
    - speed: 1000
    - duplex: full
    - rx: on
    - tx: off
    - sg: on
    - tso: off
    - ufo: off
    - gso: off
    - gro: off
    - lro: off
    - order: 3

{% endif %}

{% endfor %}

#network:
#  module.run:
#      - name: service.restart
#      - m_name: network
#      - order: last
 
