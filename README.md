### saltstack-base

Base environment for my Saltstack projects:
- juno-saltstack

```
file_roots:
  base:
    - /srv/salt/base/states
  openstack:
    - /srv/salt/openstack/states
 
pillar_roots:
  base:
    - /srv/salt/base/pillar
  openstack:
    - /srv/salt/openstack/states
```

```
salt '*' saltutil.refresh_pillar
salt '*' saltutil.sync_all
```
