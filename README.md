### Workstation and Node setup

##### Overview

The environment consists of multiple bare-metal servers that serve the role of either **workstation** or **node**.  
A **workstation** runs the CentOS 7 GNOME desktop.  It acts as the role of a utility node in OpenStack.    
It provides the following services for nodes:

- Repository mirror and Apache
- NTPD
- DHCP Server
- Salt Master

The workstation is configured manually.

A **node** runs the CentOS 7 minimal install.  They are installed using an automated installer built with kickstart.

#### Steps

1. Install CentOS 7 GNOME desktop on Workstation  
2. Set security policies as root
```
setenforce 0
systemctl stop firewalld
systemctl disable firewalld
```   
3. Configure GitHub and pull juno-saltstack as devops user
```
mkdir ~/git ; cd ~/git
git clone https://github.com/dkilcy/juno-saltstack.git
```   
4. Set the hosts file as root
```
mv /etc/hosts /etc/hosts.`date +%s`
cp /home/devops/git/juno-saltstack/files/workstation/etc/hosts /etc/hosts
```   
5. Add the EPEL and OpenStack repositories  
```
yum install -y yum-plugin-priorities
yum install -y http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-2.noarch.rpm
yum install -y http://rdo.fedorapeople.org/openstack-juno/rdo-release-juno.rpm
yum update -y
yum upgrade -y
```   
6. Create the repository mirror  
```
mkdir -p /data/repo/centos/7/x86_64/base
mkdir -p /data/repo/centos/7/x86_64/updates
mkdir -p /data/repo/centos/7/x86_64/extras
mkdir -p /data/repo/centos/7/x86_64/epel
mkdir -p /data/repo/centos/7/x86_64/openstack-juno

createrepo /data/repo/centos/7/x86_64/base
createrepo /data/repo/centos/7/x86_64/updates
createrepo /data/repo/centos/7/x86_64/extras
createrepo /data/repo/centos/7/x86_64/epel
createrepo /data/repo/centos/7/x86_64/openstack-juno

reposync -p /data/repo/centos/7/x86_64 --repoid=base
reposync -p /data/repo/centos/7/x86_64 --repoid=updates
reposync -p /data/repo/centos/7/x86_64 --repoid=extras
reposync -p /data/repo/centos/7/x86_64 --repoid=epel
reposync -p /data/repo/centos/7/x86_64 --repoid=openstack-juno

sed "s/gpgcheck=1/gpgcheck=1\nenabled=0/g" /etc/yum.repos.d/CentOS-Base.repo > /etc/yum.repos.d/CentOS-Base.repo
cp /home/devops/git/juno-saltstack/files/workstation/etc/yum.repos.d/local.repo /etc/yum.repos.d/local.repo
```
The createrepo program does not download the group information (i.e `yum grouplist` fails)
It must be downloaded manually

http://mirror.umd.edu/centos/7/os/x86_64/repodata/


```
cp /home/devops/Downloads/4b9ac2454536a901fecbc1a5ad080b0efd74680c6e1f4b28fb2c7ff419872418-c7-x86_64-comps.xml.gz comps.xml.gz
gzip -d comps.xml.gz 
cp comps.xml  /data/repo/centos/7/x86_64/base/
createrepo -g comps.xml /data/repo/centos/7/x86_64/base

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

cd srv
ln -s /home/devops/git/juno-saltstack/salt .
ln -s /home/devops/git/juno-saltstack/salt .
ln -s /home/devops/git/juno-saltstack/pillar .

systemctl restart salt-master
systemctl enable salt-master
```

11. Create the kickstart image for nodes  

12. 
### Workstation Setup

##### Tasks:

  1. [] Install CentOS 7 GNOME Desktop
  2. [] Set security policies
  3. [] Configure GitHub and pull juno-saltstack
  4. [] Set the hosts file
  5. [] Add the EPEL and OpenStack repositories
  6. [] Create the repository mirror
  7. [] Setup apache
  8. [] Setup NTPD
  9. [] Setup DHCP server
  10. [] Setup salt master
  11. [] Create the kickstart image for nodes

#### Steps

1. Install CentOS 7 GNOME desktop on Workstation  
2. Set security policies as root
```
setenforce 0
systemctl stop firewalld
systemctl disable firewalld
```   
3. Configure GitHub and pull juno-saltstack as devops user
```
mkdir ~/git ; cd ~/git
git clone https://github.com/dkilcy/juno-saltstack.git
```   
4. Set the hosts file as root
```
mv /etc/hosts /etc/hosts.`date +%s`
cp /home/devops/git/juno-saltstack/files/workstation/etc/hosts /etc/hosts
```   
5. Add the EPEL and OpenStack repositories  
```
yum install -y yum-plugin-priorities
yum install -y http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-2.noarch.rpm
yum install -y http://rdo.fedorapeople.org/openstack-juno/rdo-release-juno.rpm
yum update -y
yum upgrade -y
```   
6. Create the repository mirror  
```
mkdir -p /data/repo/centos/7/x86_64/base
mkdir -p /data/repo/centos/7/x86_64/updates
mkdir -p /data/repo/centos/7/x86_64/extras
mkdir -p /data/repo/centos/7/x86_64/epel
mkdir -p /data/repo/centos/7/x86_64/openstack-juno

createrepo /data/repo/centos/7/x86_64/base
createrepo /data/repo/centos/7/x86_64/updates
createrepo /data/repo/centos/7/x86_64/extras
createrepo /data/repo/centos/7/x86_64/epel
createrepo /data/repo/centos/7/x86_64/openstack-juno

reposync -p /data/repo/centos/7/x86_64 --repoid=base
reposync -p /data/repo/centos/7/x86_64 --repoid=updates
reposync -p /data/repo/centos/7/x86_64 --repoid=extras
reposync -p /data/repo/centos/7/x86_64 --repoid=epel
reposync -p /data/repo/centos/7/x86_64 --repoid=openstack-juno

sed "s/gpgcheck=1/gpgcheck=1\nenabled=0/g" /etc/yum.repos.d/CentOS-Base.repo > /etc/yum.repos.d/CentOS-Base.repo
cp /home/devops/git/juno-saltstack/files/workstation/etc/yum.repos.d/local.repo /etc/yum.repos.d/local.repo
```
The createrepo program does not download the group information (i.e `yum grouplist` fails)
It must be downloaded manually

http://mirror.umd.edu/centos/7/os/x86_64/repodata/


```
cp /home/devops/Downloads/4b9ac2454536a901fecbc1a5ad080b0efd74680c6e1f4b28fb2c7ff419872418-c7-x86_64-comps.xml.gz comps.xml.gz
gzip -d comps.xml.gz 
cp comps.xml  /data/repo/centos/7/x86_64/base/
createrepo -g comps.xml /data/repo/centos/7/x86_64/base

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

cd srv
ln -s /home/devops/git/juno-saltstack/salt .
ln -s /home/devops/git/juno-saltstack/salt .
ln -s /home/devops/git/juno-saltstack/pillar .

systemctl restart salt-master
systemctl enable salt-master
```

11. Create the kickstart image for nodes  

12. 
=======
### saltstack-base

Base environment for my Saltstack projects:
- juno-saltstack

```
file_roots:
  base:
    - /srv/salt/base/states
  openstack:
    - /srv/salt/openstack/states
 
pillar_roots:
  base:
    - /srv/salt/base/pillar
  openstack:
    - /srv/salt/openstack/states
```

```
salt '*' saltutil.refresh_pillar
salt '*' saltutil.sync_all
```
