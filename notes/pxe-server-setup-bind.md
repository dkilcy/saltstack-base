
### PXE Server setup using BIND

Install and setup PXE server on CentOS 7. 

Install packages:
- dhcp
- tftp-server
- syslinux
- httpd

```
# vi /etc/dhcp/dhcpd.conf
```
```
subnet 10.0.0.0 netmask 255.255.255.0 {
  range 10.0.0.10 10.0.0.255;
  default-lease-time 86400;
  max-lease-time 86400;
  option routers 10.0.0.1;
  option ip-forwarding off;
  option broadcast-address 10.0.0.255;
  option subnet-mask 255.255.255.0;
  option domain-name-servers 10.0.0.6;

  allow booting;
  allow bootp;

  next-server 10.0.0.6;
  filename "/pxelinux.0";

  host controller1 {
    hardware ethernet 0c:c4:7a:31:68:0c;
    fixed-address 10.0.0.11;
  }
  ...
}
```

```
# cd /usr/share/syslinux
# cp chain.c32 mboot.c32 memdisk menu.c32 pxelinux.0 /var/lib/tftpboot/
# mkdir /var/lib/tftpboot/pxelinux.cfg/
```

Create /var/lib/tftpboot/pxelinux.cfg/default
```
default menu.c32
prompt 0
timeout 300
ONTIMEOUT local

menu title ########## PXE Boot Menu ##########

label 1
menu label ^1) Install CentOS 7 x64 with local repo
kernel /var/repo/yum/centos/7/os/x86_64/isolinux/vmlinuz
append initrd=/var/repo/yum/centos/7/os/x86_64/isolinux/initrd.img method=http://10.0.0.6/repo/centos/7/os/x86_64/ devfs=nomount

label 2
menu label ^3) Boot from local drive
```

Symlink /var/www/html/repo to /var/repo/yum

- Start dhcpd: `service dhcpd start`
- Start httpd: `service httpd start'



##### References
- [PXE Boot Linux Install CentOS 6](https://conradjonesit.wordpress.com/2013/07/10/pxe-boot-linux-install-centos-6-part-3-setting-the-hostname-ip/)
