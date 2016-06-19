
/etc/hosts:
  file.managed:
    - name: /etc/hosts
    - source: salt://network/files/hosts
    - replace: True

/usr/local/bin/set_irq_affinity.sh:
  file.managed:
    - name: /usr/local/bin/set_irq_affinity.sh
    - source: salt://network/files/set_irq_affinity.sh
    - replace: True
    - mode: 755

{% set id = grains['id'] %}

{% for num in range(0,2) %}

{% set team = 'team' + num|string %}

{% if pillar['systems']['network'][team] is defined %}

{% set nic0        = pillar['systems']['network'][team]['nic0'] %}
{% set nic1        = pillar['systems']['network'][team]['nic1'] %}

affinity_{{ id }}_{{ nic0 }}:
  file.append:
    - name: /etc/rc.d/rc.local
    - text:
      - '/usr/local/bin/set_irq_affinity.sh {{ nic0 }} {{ nic1 }}'

{% endif %}

{% endfor %}

