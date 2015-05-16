
### dhcp

1. Install DHCP server   

 ```bash
yum install dhcp
#mv /etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd.conf.`date +%s`
#cp /home/devops/git/juno-saltstack/files/workstation/etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd.conf
systemctl start dhcpd.service
systemctl enable dhcpd.service
```
