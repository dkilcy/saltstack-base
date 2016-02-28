
{% set id = grains['id'] %}

{% for num in range(0,2) %}

{% set team = 'team' + num|string %}

{% if pillar['systems']['network'][team] is defined %}

{% set nic0        = pillar['systems']['network'][team]['nic0'] %}
{% set nic1        = pillar['systems']['network'][team]['nic1'] %}
{% set ipaddr      = pillar['systems']['network'][team]['ipaddr'] %}
{% set team_config = pillar['systems']['network'][team]['team_config'] %}

{{ id }}_{{ nic0 }}:
  file.managed:
    - name: /etc/sysconfig/network-scripts/ifcfg-{{ nic0 }}
    - contents: |
        DEVICE="{{ nic0 }}"
        DEVICETYPE="TeamPort"
        ONBOOT="yes"
        BOOTPROTO="none"
        TEAM_MASTER="{{ team }}"
        IPV6INIT="yes"
  
{{ id }}_{{ nic1 }}:
  file.managed:
    - name: /etc/sysconfig/network-scripts/ifcfg-{{ nic1 }}
    - contents: |
        DEVICE="{{ nic1 }}"
        DEVICETYPE="TeamPort"
        ONBOOT="yes"
        BOOTPROTO="none"
        TEAM_MASTER="{{ team }}"
        IPV6INIT="yes"

{{ id }}_{{ team }}:
  file.managed:
    - name: /etc/sysconfig/network-scripts/ifcfg-{{ team }}
    - contents: |
        DEVICE="{{ team }}"
        DEVICETYPE="Team"
        ONBOOT="yes"
        BOOTPROTO="none"
        IPADDR={{ ipaddr }}
        NETMASK=255.255.255.0
        TEAM_CONFIG='{{ team_config }}'
        MTU=9000

{% endif %}

{% endfor %}

