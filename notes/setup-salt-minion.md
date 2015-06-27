
### Salt Minion


6. Configure and start the Salt minion on the workstation machine as **root** user.

 ```bash
hostname -s > /etc/salt/minion_id

systemctl start salt-minion.service
systemctl enable salt-minion.service
```

7. Add the minion to the master as root user.

 ```bash
[root@workstation1 minion.d]# salt-key -L
Accepted Keys:
Unaccepted Keys:
workstation1
Rejected Keys:
[root@workstation1 minion.d]# salt-key -A 
The following keys are going to be accepted:
Unaccepted Keys:
workstation1
Proceed? [n/Y]  
Key for minion workstation1 accepted.
```

6. Test the installation as root user.

 ```bash
salt '*' test.ping
```

7. Update the local minion with the pillar data as root user.

 ```bash
salt '*' saltutil.refresh_pillar
```

8. Set the grains for the Salt master:

 ```bash
salt 'workstation*' grains.setvals "{'saltstack-base:{'role':'master'}}"
```


1. Install OS from PXE server
2. **From the Salt master:** Accept the key and set the role grain for the minion: 

 ```bash
salt-key -L
salt '*' test.ping
salt '*' saltutil.refresh_pillar
salt 'store*' grains.setvals "{'saltstack-base':{'role':'minion'}}"
```
 
 
 
