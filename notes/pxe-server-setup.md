
### PXE Network Boot Server Setup

Install and setup PXE server on CentOS 7.  

Install packages:
- dnsmasq: provides DNS and DHCP services
- syslinux: bootloaders for network booting
- tftp-server: server bootable imaes
- vsftpd

Setup dnsmasq:
```
vi /etc/dnsmasq.conf
```
```
# Interface to listen on
interface=enp5s0

# Domainname
#domain=

# DHCP IP range
dhcp-range=10.0.0.200,10.0.0.224,255.255.255.0,12h

# PXE
dhcp-boot=pxelinux.0,pxeserver,10.0.0.6

# Gateway
#dhcp-option=3,10.0.0.1

# DNS server
dhcp-option=6,10.0.0.6

# Broadcast
dhcp-option=28,10.0.0.255

# NTP server
dhcp-option=42,10.0.0.6

pxe-prompt="Press F8 for menu.", 60
pxe-service=x86PC, "Install CentOS 7 from network server", pxelinux
enable-tftp
tftp-root=/var/lib/tftpboot

# Persistent IP addresses
dhcp-host=00:25:90:f1:4f:96,10.0.0.61
dhcp-host=00:25:90:f1:0c:6c,10.0.0.62
```

Copy bootloaders: `cp -r /usr/share/syslinux/* /var/lib/tftpboot/`
Setup PXE config files:
```
# mkdir /var/lib/tftpboot/pxelinux.cfg
# vi /var/lib/tftpboot/pxelinux.cfg/default
```
```
default menu.c32
prompt 0
timeout 300
ONTIMEOUT local

menu title ########## PXE Boot Menu ##########

label 1
menu label ^1) Install CentOS 7 x64 with Local Repo
kernel centos7/vmlinuz
append initrd=centos7/initrd.img method=ftp://10.0.0.6/pub devfs=nomount

label 2
menu label ^2) Install CentOS 7 x64 with http://mirror.centos.org Repo
kernel centos7/vmlinuz
append initrd=centos7/initrd.img method=http://mirror.centos.org/centos/7/os/x86_64/ devfs=nomount ip=dhcp

label 3
menu label ^3) Boot from local drive
```

```
# mkdir /var/lib/tftpboot/centos7
# mount -o loop /var/repo/iso/CentOS-7.0-1406-x86_64-Everything.iso /mnt
# cp /mnt/images/pxeboot/vmlinuz /var/lib/tftpboot/centos7
# cp /mnt/images/pxeboot/initrd.img /var/lib/tftpboot/centos7

# mkdir -p /var/ftp/pub/
# cp -r /mnt/* /var/ftp/pub/
# \cp -rf /mnt/. /var/ftp/pub  # yes | cp -ri /mnt/. /var/ftp/pub
# chmod -R 755 /var/ftp/pub

# umount /mnt
# systemctl stop dhcpd.service
# systemctl start dnsmasq
# systemctl status dnsmasq
# systemctl start vsftpd
# systemctl status vsftpd
```

### Test

ftp://10.0.0.6/pub/

## Things to check
- Missing:
  - ftp://10.0.0.6/pub/images/product.img
  - ftp://10.0.0.6/pub/images/updates.img



##### References

- [Setting up a ‘PXE Network Boot Server’ for Multiple Linux Distribution Installations in RHEL/CentOS 7](http://www.tecmint.com/install-pxe-network-boot-server-in-centos-7/)
- [PXE Boot Linux Install CentOS 6 – Part 1](https://conradjonesit.wordpress.com/2013/07/07/pxe-boot-linux-install-centos-6/)
