
### PXE Server Setup

Create a PXE Server that can serve out both CentOS 6 and 7 images.

1. As root, create the directory /var/tmp/iso and get the required binaries

Using wget:

 ```bash
  mkdir -p /var/tmp/iso/centos/7 /var/tmp/iso/centos/6
  
  cd /var/tmp/iso/centos/7
  wget http://mirror.umd.edu/centos/7/isos/x86_64/CentOS-7-x86_64-Everything-1511.iso
  wget http://mirror.umd.edu/centos/7.2.1511/os/x86_64/isolinux/initrd.img
  wget http://mirror.umd.edu/centos/7.2.1511/os/x86_64/isolinux//vmlinuz
  
  cd /var/tmp/iso/centos/6
  wget http://mirror.umd.edu/centos/6/isos/x86_64/CentOS-6.7-x86_64-bin-DVD1.iso
  wget http://mirror.umd.edu/centos/6/os/x86_64/isolinux/initrd.img
  wget http://mirror.umd.edu/centos/6/os/x86_64/isolinux/vmlinuz
  ```


2. Call the pxeserver state to setup the PXE Server components

 ```bash
 salt 'workstation1' state.sls pxeserver
 ```

 State file does the following
 - Installs dhcp, httpd, syslinux, tftp-server and vsftpd
 - Creates the /var/www/html/repo directory to host files with Apache (destination of reposync.sh)
 - Installs the kickstart files to /var/www/html/repo
 - Generate the /etc/dhcpd.conf file
 - Recursively copies the bootloaders from /usr/share/syslinux/* to /var/lib/tftpboot
 - Installs the default to /var/lib/tftpboot/pxelinux.cfg directory
 - Installs the bootstrap files from /var/tmp/iso to /var/lib/tftpboot/centos/7 and 6
 - Mounts the CentOS 7 and 6 ISOs in /var/ftp/pub/centos (if you reboot the server you need to run the state again)
 - Copies the reposync.sh script to /usr/local/bin
 - Starts the httpd, dhcp, xvtpd and xinetd services

3. Run the reposync.sh script to populate the /var/www/html/repo directory. This can take a very long time for the 1st iteration.  It uses the University of Maryland which is fast for me.  You will want to change to the mirror that is fastest for you.  Add to cron to run nightly to sync with your mirror.

Using reposync.sh: 
 ```bash
/usr/local/bin/reposync.sh
```

```
[root@workstation2 pillar]$ cat /etc/crontab 
SHELL=/bin/bash
PATH=/sbin:/bin:/usr/sbin:/usr/bin
MAILTO=root

0 4 * * * root /usr/local/bin/reposync.sh > /var/log/reposync.out 2>&1
```

4. Verify the installation

##### Install from the PXE Server

- Boot the machine 
- Hold the F12 key to activate the Network Boot
- At the boot menu, select CentOS 7 - Kickstart

Troubleshooting: hit Tab at the boot menu 
 
##### References
- [CentOS: Install PXE Server On CentOS 7](ravindrayadava.blogspot.com/2014/10/centos-install-pxe-server-on-centos-7.html)
- [Setting up a ‘PXE Network Boot Server’ for Multiple Linux Distribution Installations in RHEL/CentOS 7](http://www.tecmint.com/install-pxe-network-boot-server-in-centos-7/)
- [PXE Boot Linux Install CentOS 6 – Part 1](https://conradjonesit.wordpress.com/2013/07/07/pxe-boot-linux-install-centos-6/)

