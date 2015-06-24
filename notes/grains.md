
### Salt Grains

- Return all grains: `salt 'store1' grains.items`
- Get one grain: `salt 'store1' grains.get id`
- Setting a grain: `salt 'store1' grains.setvals "{'saltstack-base:{'role':'minion'}}"`
- Run test.ping against all grains that has a saltstack-base:role grain:  `# salt -G 'saltstack-base:role:minion' test.ping`
- Matching minions in a pillar file using a grain:

```yaml
base:
  'G@saltstack-base:role:master':  
    - local
```

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
