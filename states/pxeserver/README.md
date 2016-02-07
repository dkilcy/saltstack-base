
### PXE Server Setup

Create a PXE Server that can serve out both CentOS 6 and 7 images.

1. As root, create the directory /var/tmp/iso and get the required binaries

Using wget:

 ```bash
  mkdir -p /var/tmp/iso/centos/7 /var/tmp/iso/centos/6
  
  cd /var/tmp/iso/centos/7
  wget http://mirror.umd.edu/centos/7/isos/x86_64/CentOS-7-x86_64-Everything-1511.iso
  wget http://http://mirror.umd.edu/centos/7/os/x86_64/isolinux/initrd.img
  wget http://http://mirror.umd.edu/centos/7/os/x86_64/isolinux/vmlinuz
  
  cd /var/tmp/iso/centos/6
  wget http://mirror.umd.edu/centos/6/isos/x86_64/CentOS-6.7-x86_64-bin-DVD1.iso
  wget http://http://mirror.umd.edu/centos/6/os/x86_64/isolinux/initrd.img
  wget http://http://mirror.umd.edu/centos/6/os/x86_64/isolinux/vmlinuz
  ```


2. Call the pxeserver state to setup the PXE Server components

 ```bash
 salt 'workstation1' state.sls pxeserver
 ```

 State file does the following
 - Installs dhcp, httpd, syslinux, tftp-server and vsftpd
 - Creates the /var/www/html/repo directory to host files with Apache (destination of reposync.sh)
 - Generate the /etc/dhcpd.conf file
 - Recursively copies the bootloaders from /usr/share/syslinux/* to /var/lib/tftpboot
 - Installs the default to /var/lib/tftpboot/pxelinux.cfg directory
 - Installs the bootstrap files from /var/tmp/iso to /var/lib/tftpboot/centos/7 and 6
 - Mounts the CentOS 7 and 6 ISOs in /var/ftp/pub/centos
 - Copies the reposync.sh script to /usr/local/bin
 - Starts the httpd, dhcp, xvtpd and xinetd services

3. Populate the /var/www/html/repo directory using rsync or reposync.sh  

Using reposync.sh: 
 ```bash
/usr/local/bin/reposync.sh
```
4. Verify the installation

##### Install from the PXE Server

- Boot the machine 
- 
- Get the kernel prompt: At GRUB menu, highlight **Install CentOS 7** then hit **Tab**
- Set the kickstart network device: `ksdev=enp0s20f0`
- Set the kickstart URL: `ks=http://10.0.0.6/base.ks` 
 
##### References

- [Setting up a ‘PXE Network Boot Server’ for Multiple Linux Distribution Installations in RHEL/CentOS 7](http://www.tecmint.com/install-pxe-network-boot-server-in-centos-7/)
- [PXE Boot Linux Install CentOS 6 – Part 1](https://conradjonesit.wordpress.com/2013/07/07/pxe-boot-linux-install-centos-6/)

