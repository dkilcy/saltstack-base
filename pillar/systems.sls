
systems:
{% if grains['id'] == 'store1' %}
  network:
    bond0: 
      ipaddr: 10.0.0.41
      nic0: eth0
      nic1: eth1
    bond1: 
      ipaddr: 10.0.1.41
      nic0: eth2
      nic1: eth3
{% elif grains['id'] == 'store2' %}
  network:
    bond0:  
      ipaddr: 10.0.0.42
      nic0: eth0
      nic1: eth1
    bond1:  
      ipaddr: 10.0.1.42
      nic0: eth2
      nic1: eth3
{% elif grains['id'] == 'store3' %}
  network:
    bond0:
      ipaddr: 10.0.0.43
      nic0: eth0
      nic1: eth1
    bond1:
      ipaddr: 10.0.1.43
      nic0: eth2
      nic1: eth3
{% elif grains['id'] == 'store4' %}
  network:
    bond0:
      ipaddr: 10.0.0.44
      nic0: eth0
      nic1: eth1
    bond1:
      ipaddr: 10.0.1.44
      nic0: eth2
      nic1: eth3
{% elif grains['id'] == 'store5' %}
  network:
    bond0:
      ipaddr: 10.0.0.45
      nic0: eth0
      nic1: eth1
    bond1:
      ipaddr: 10.0.1.45
      nic0: eth2
      nic1: eth3
{% elif grains['id'] == 'store6' %}
  network:
    bond0:
      ipaddr: 10.0.0.46
      nic0: eth0
      nic1: eth1
    bond1:
      ipaddr: 10.0.1.46
      nic0: eth2
      nic1: eth3
{% elif grains['id'] == 'controller1' %}
  network:
    bond0: 
      ipaddr: 10.0.0.31
      nic0: enp0s20f0
      nic1: enp0s20f1
{% endif %}

