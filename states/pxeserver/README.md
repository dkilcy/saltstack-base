
### PXE Server Setup


1. Call the pxeserver state to setup the PXE Server components
 ```bash
salt 'workstation1' state.sls pxeserver
```

2. Populate the /var/lib/repo directory using rsync or reposync.sh  
Using rsync: 
 ```bash
rsync -avrz /var/lib/repo/* root@workstation2:/var/lib/repo
rsync -avrz /var/tmp/iso* root@workstation2:/var/tmp/iso```
```
Using reposync.sh: `/usr/local/bin/reposync.sh`

3. Populate the /var/tmp/iso directory with image files
 ```bash
 wget ...
 ```

##### Notes

- Get the kernel prompt: At GRUB menu, highlight **Install CentOS 7** then hit **Tab**
- Set the kickstart network device: `ksdev=enp0s20f0`
- Set the kickstart URL: `ks=http://10.0.0.6/base.ks` 
 
