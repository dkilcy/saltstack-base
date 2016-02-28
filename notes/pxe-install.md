
### Install Supermicros (or other MintBox2) via PXE Server

#### Install Supermicro from the PXE Server

1. Hook up your crash cart and boot the machine 
2. Hold the F12 key to activate the Network Boot
3. At the boot menu, select CentOS 7 - Kickstart
4. Wait for the automated install to complete
5. Login from the console to verify the installation.
6. From the Salt Master:
    - accept the key from the salt minion:  `salt-key -a <minion_id>`
    - Verify connectivity to the Salt minion: `salt <minion_id> test.ping`
    - Assign the node the minion role: `salt <minion_id> grains.setvals "{'saltstack-base':{'role':'minion'}}"`
    - Configure networking:  `salt <minion_id> state.sls network.team`
10. From the console:
    - restart networking: `service network restart`
    - Restart networking again: `service network restart`
    - Verify connectivity: `ping salt`
11. Verify the connectivity for the Supermicro

#### Notes

ALT: Setup networking for CentOS 6 servers
```bash
salt '<minion_id>' state.sls iptables saltenv=base
salt '<minion_id>' state.sls selinux saltenv=base
salt '<minion_id>' state.sls network.bond saltenv=base
```
