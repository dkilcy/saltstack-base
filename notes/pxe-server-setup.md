
### PXE Server

- Setup DHCP
- Install Apache
- Setup the yum repository
- Setup the PXE server

6. Install DHCP server   

 ```bash
yum install dhcp
mv /etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd.conf.`date +%s`
#cp /home/devops/git/saltstack-base/dhcp/files/dhcpd.conf /etc/dhcp/
#systemctl start dhcpd.service
#systemctl enable dhcpd.service
```

4. Setup apache to host the yum repository 
 
 ```bash
yum install httpd
systemctl start httpd.service
systemctl enable httpd.service
```

3. Install the reposync.sh tool as **root** user.

 ```bash
cp /home/devops/git/saltstack-base/states/yumrepo/files/reposync.sh /usr/local/bin/
```

