
### Setup Salt Master and Minion on MintBox2

Perform all these steps on the workstation node as **root** user

1. Install the Salt master 

 ```bash
 yum install salt-master
 ```

2. Verify the installation

 ```bash
 [root@workstation2 ~]# salt --version
 salt 2015.5.0 (Lithium)
 [root@workstation2 ~]# 
 ```

3. Create the /etc/salt/master.d file to hold configuration files

 ```bash
 mkdir -p /etc/salt/master.d
 ```

4. Star the Salt master

 ```bash
 systemctl start salt-master.service
 systemctl enable salt-master.service
 ```

5. Install the Salt minion

 ```bash
 # yum install salt-minion
 ```

6. Verify the installation

 ```bash
 [root@workstation2 ~]# salt-call --version
 salt-call 2015.5.0 (Lithium)
 [root@workstation2 ~]# 
 ```

7. Set the minion ID as the short hostname

 ```bash
 # hostname -s > /etc/salt/minion_id
 ```

8. Start the Salt minion 

 ```bash
 systemctl start salt-minion.service
 systemctl enable salt-minion.service
 ```

9. Add the minion to the master.

 ```bash
[root@workstation2 ~]# salt-key -L
Accepted Keys:
Unaccepted Keys:
workstation2
Rejected Keys:
```

 ```bash
[root@workstation2 ~]# salt-key -A 
The following keys are going to be accepted:
Unaccepted Keys:
workstation2
Proceed? [n/Y]  
Key for minion workstation2 accepted.
```

10. Test the installation

 ```bash
salt '*' test.ping
```

11. Update the local minion with the pillar data as root user.

 ```bash
 salt '*' saltutil.refresh_pillar
 ```

12. Set the grains for the Salt master:

 ```bash
 salt 'workstation2' grains.setvals "{'saltstack-base:{'role':'master'}}"
 ```
