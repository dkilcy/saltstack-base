
### Install Supermicros (or other MintBox2) via PXE Server

#### Install Supermicro from the PXE Server

1. Boot the machine 
2. Hold the F12 key to activate the Network Boot
3. At the boot menu, select CentOS 7 - Kickstart
4. Wait for the automated install to complete
5. Login to the console and verify the install
6. From the Salt Master, accept the key from the salt minion:  `salt-key -a <minion_id>`
7. Test the connectivity to the Salt minion: `salt <minion_id> test.ping`
8. Assign the node the minion role: `salt <minion_id> grains.setvals "{'saltstack-base':{'role':'minion'}}"`
9. Setup networking:  `salt <minion_id> network.team`
10. Reboot the servers to activate networking: `salt <minion_id> cmd.run 'reboot'`

#### Notes

ALT: Setup networking for CentOS 6 servers
```bash
salt '<minion_id>' state.sls iptables saltenv=base
salt '<minion_id>' state.sls selinux saltenv=base
salt '<minion_id>' state.sls network.bond saltenv=base
```
