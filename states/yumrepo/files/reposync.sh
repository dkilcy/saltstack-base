
##exit

####################################################################################
### CentOS 6
####################################################################################

mkdir -p /var/repo/yum/centos/6/os
mkdir -p /var/repo/yum/centos/6/updates
mkdir -p /var/repo/yum/centos/6/extras

cd /var/repo/yum/centos/6

rsync -avrt rsync://mirror.umd.edu/centos/6/os .
rsync -avrt rsync://mirror.umd.edu/centos/6/updates .
rsync -avrt rsync://mirror.umd.edu/centos/6/extras .

####################################################################################
### CentOS 6 - EPEL 
####################################################################################

mkdir -p /var/repo/yum/centos/6/epel

cd /var/repo/yum/centos/6/epel

rsync -avrt rsync://mirror.pnl.gov/epel/6/i386 .
rsync -avrt rsync://mirror.pnl.gov/epel/6/x86_64 .

####################################################################################
### CentOS 6 - Scality Lorien
####################################################################################

####################################################################################
### CentOS 7
####################################################################################

mkdir -p /var/repo/yum/centos/7/os
mkdir -p /var/repo/yum/centos/7/updates
mkdir -p /var/repo/yum/centos/7/extras

cd /var/repo/yum/centos/7

rsync -avrt rsync://mirror.umd.edu/centos/7/os .
rsync -avrt rsync://mirror.umd.edu/centos/7/updates .
rsync -avrt rsync://mirror.umd.edu/centos/7/extras .

####################################################################################
### CentOS 7 - EPEL
####################################################################################

mkdir -p /var/repo/yum/centos/7/epel

cd /var/repo/yum/centos/7/epel

rsync -avrt rsync://mirror.pnl.gov/epel/7/x86_64 .

####################################################################################

exit

####################################################################################
### CentOS 7 - Scality Lorien
####################################################################################

reposync -p /var/repo/yum/centos/7 --repoid=scality-lorien
createrepo /var/repo/yum/centos/7/scality-lorien

####################################################################################
### CentOS 7 - Openstack Kilo
####################################################################################

reposync -p /var/repo/yum/centos/7 --repoid=openstack-kilo
createrepo /var/repo/yum/centos/7/openstack-kilo

####################################################################################

