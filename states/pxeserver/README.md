
### PXE Server Setup

1. Populate the /var/tmp/iso directory with image files.  

Using wget:

 ```bash
 cd /var/tmp/iso
 wget http://mirror.umd.edu/centos/7/isos/x86_64/CentOS-7-x86_64-Everything-1503-01.iso
 wget http://mirror.umd.edu/centos/6/isos/x86_64/CentOS-6.6-x86_64-bin-DVD1.iso
 ```
Using rsync from an existing workstation:

 ```bash
rsync -avrz /var/tmp/iso/* root@workstation2:/var/tmp/iso/
```

2. Call the pxeserver state to setup the PXE Server components
 ```bash
salt 'workstation1' state.sls pxeserver
```

 State file does the following
 - Installs dhcp, httpd, syslinux, tftp-server and vsftpd
 - Creates the /var/lib/repo and /var/tmp/iso directories
 - Creates a symbolic link from /var/lib/repo to /var/www/html/repo
 - Copies over the dhcpd.conf file to /etc (TODO: generate dhcpd.conf)
 - Creates the /var/lib/tftpboot/centos/6 and 7 directories
 - Recursively copies the bootloaders from /usr/share/syslinux/* to /var/lib/tftpboot
 - Installs the default to /var/lib/tftpboot/pxelinux.cfg directory
 - Mounts the CentOS 7 and 6 ISOs in /var/ftp/pub/centos
 - Copies vminuz and initrd.img to the pxeboot directories
 - Copies the reposync.sh script to /usr/local/bin


3. Populate the /var/lib/repo directory using rsync or reposync.sh  

Using reposync.sh: 
 ```bash
/usr/local/bin/reposync.sh
```

Using rsync from an existing workstation: 
 ```bash
rsync -avrz /var/lib/repo/* root@workstation2:/var/lib/repo/
```

##### Notes

- Get the kernel prompt: At GRUB menu, highlight **Install CentOS 7** then hit **Tab**
- Set the kickstart network device: `ksdev=enp0s20f0`
- Set the kickstart URL: `ks=http://10.0.0.6/base.ks` 
 
##### References

- [Setting up a ‘PXE Network Boot Server’ for Multiple Linux Distribution Installations in RHEL/CentOS 7](http://www.tecmint.com/install-pxe-network-boot-server-in-centos-7/)
- [PXE Boot Linux Install CentOS 6 – Part 1](https://conradjonesit.wordpress.com/2013/07/07/pxe-boot-linux-install-centos-6/)

