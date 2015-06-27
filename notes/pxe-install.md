
### PXE Install


#### Post-Install


TODO: setup networking, just for storage nodes
```bash
salt '<minion_id>' state.sls iptables saltenv=base
salt '<minion_id>' state.sls selinux saltenv=base
salt '<minion_id>' state.sls network.bond saltenv=base
```

TODO: setup networking for OpenStack 
```
salt 'controller*' state.sls network.team
salt 'network*' state.sls network.team
salt 'compute*' state.sls network.team
```
From console: `systemctl restart network.service`

