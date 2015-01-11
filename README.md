### saltstack-base

Base environment for my Saltstack projects:
- juno-saltstack

Create a file called /etc/salt/master.d/99-salt-envs.conf

```
file_roots:
  base:
    - /srv/salt/base/states
pillar_roots:
  base:
    - /srv/salt/base/pillar
```

Restart Salt Master after adding file.
```
systemctl restart salt-master.service
salt '*' test.ping
salt '*' saltutil.refresh_pillar
salt '*' saltutil.sync_all
```

#### Setup Salt Master

1. Install CentOS 7 with Mate desktop
2. Set security policies as root
```
setenforce 0
systemctl stop firewalld
systemctl disable firewalld
```   
3. Configure GitHub and pull juno-saltstack as devops user
```
mkdir ~/git ; cd ~/git
git clone https://github.com/dkilcy/saltstack-base.git
git clone https://github.com/dkilcy/juno-saltstack.git
```   
4. Set the hosts file as root
```
mv /etc/hosts /etc/hosts.`date +%s`
cp /home/devops/git/juno-saltstack/files/workstation/etc/hosts /etc/hosts
```   
5. Add the EPEL and update
```
yum install -y http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-2.noarch.rpm
yum update -y
yum upgrade -y
```   
6. Create the repository mirror  
```
reposync.sh

yum clean all
yum update

yum grouplist
```

7. Setup apache  
```
yum install -y httpd
systemctl start httpd
systemctl enable httpd
```

8. Setup NTPD  
```
systemctl start ntpd
systemctl enable ntpd
ntpq -p
```

9. Setup DHCP server   
```
yum install -y dhcp
mv /etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd.conf.`date +%s`
cp /home/devops/git/juno-saltstack/files/workstation/etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd.conf
systemctl start dhcpd
systemctl enable dhcpd
```

10. Setup salt master  
```
yum install salt-master

ln -sf /home/devops/git/saltstack-base /srv/salt/base

systemctl restart salt-master
systemctl enable salt-master
```

11. Create the kickstart image for nodes  

12. Setup Nodes
13. 

