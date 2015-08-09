
### Salt Grains

- Return all grains: `salt 'store1' grains.items`
- Get one grain: `salt 'store1' grains.get id`
- Get one grain: `salt 'store1' grains.get selinux:enabled`
- Get a list of grains: `salt 'store1' grains.get saltversioninfo`
- Get a list of grains: `salt 'store1' grains.get ip_interfaces`
- Get the first item in the list: `salt 'store1' grains.get saltversioninfo:0`  ## doesnt work????
- Get the first item in the list: `salt 'store1' grains.get ip_interfaces:bond0:0`
- Setting a grain: `salt 'store1' grains.setvals "{'saltstack-base:{'role':'minion'}}"`
- Match all grains that have saltstack-base:role grain:  `# salt -G 'saltstack-base:role:minion' test.ping`
- Using a grain in a state file: `{% set id = salt['pillar.get']('id') %}`
- Jinja templating: `salt '*' cmd.run template=jinja 'echo {{ grains.id }} {{ grains.fqdn_ip4[0] }}'`
- Matching minions in a pillar file using a grain: 
```yaml
base:
  'G@saltstack-base:role:master':  
    - local
```
- Conditional based on grain:
```
{% if grains['os_family'] == 'RedHat' and grains['osmajorrelease'] == '7' %}
    - cpupower
{% elif grains['os_family'] == 'RedHat' and grains['osmajorrelease'] == '6' %}
    - cpuspeed
{% endif %}
```

##### References
- [SaltStack Grains](http://docs.saltstack.com/en/latest/topics/targeting/grains.html)
- [Using a grain in a configuration file](http://serverfault.com/questions/676796/how-to-use-saltstack-to-manage-different-config-file-for-different-minions)
