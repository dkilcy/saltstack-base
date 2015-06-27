
### PXE Server Setup

1. Call the pxeserver state to setup the PXE Server components
```
salt 'workstation1' state.sls pxeserver
```
2. Populate the repository directories with data

- /var/lib/repo
- /var/tmp/iso

Populate the /var/lib/repo directory using rsync or reposync.sh

Using rsync: 

- `rsync -avrz /var/lib/repo/* root@workstation2:/var/lib/repo`
- `rsync -avrz /var/tmp/iso* root@workstation2:/var/tmp/iso`

Using /usr/local/bin/reposync.sh: `/usr/local/bin/reposync.sh`

##### Notes

- Get the kernel prompt: At GRUB menu, highlight **Install CentOS 7** then hit **Tab**
- Set the kickstart network device: `ksdev=enp0s20f0`
- Set the kickstart URL: `ks=http://10.0.0.6/base.ks` 
 
