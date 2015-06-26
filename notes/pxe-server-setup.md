
### PXE Server

- Setup the yum repository
- Setup the PXE server

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

