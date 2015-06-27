
##exit

####################################################################################
### CentOS 6
####################################################################################

mkdir -p /var/lib/repo/yum/centos/6/os
mkdir -p /var/lib/repo/yum/centos/6/updates
mkdir -p /var/lib/repo/yum/centos/6/extras

cd /var/lib/repo/yum/centos/6

rsync -avrt rsync://mirror.umd.edu/centos/6/os .
rsync -avrt rsync://mirror.umd.edu/centos/6/updates .
rsync -avrt rsync://mirror.umd.edu/centos/6/extras .

####################################################################################
### CentOS 6 - EPEL 
####################################################################################

mkdir -p /var/lib/repo/yum/centos/6/epel

cd /var/lib/repo/yum/centos/6/epel

rsync -avrt rsync://mirror.pnl.gov/epel/6/i386 .
rsync -avrt rsync://mirror.pnl.gov/epel/6/x86_64 .

####################################################################################
### CentOS 6 - Scality Lorien
####################################################################################

#reposync -p /var/lib/repo/yum/centos/6/scality-lorien/x86_64 --repoid=scality-lorien-centos6 --norepopath
#createrepo /var/lib/repo/yum/centos/6/scality-lorien/x86_64


####################################################################################
### CentOS 7
####################################################################################

mkdir -p /var/lib/repo/yum/centos/7/os
mkdir -p /var/lib/repo/yum/centos/7/updates
mkdir -p /var/lib/repo/yum/centos/7/extras

cd /var/lib/repo/yum/centos/7

rsync -avrt rsync://mirror.umd.edu/centos/7/os .
rsync -avrt rsync://mirror.umd.edu/centos/7/updates .
rsync -avrt rsync://mirror.umd.edu/centos/7/extras .

####################################################################################
### CentOS 7 - EPEL
####################################################################################

mkdir -p /var/lib/repo/yum/centos/7/epel
cd /var/lib/repo/yum/centos/7/epel
rsync -avrt rsync://mirror.pnl.gov/epel/7/x86_64 .

####################################################################################

####################################################################################
### CentOS 7 - Openstack Kilo
####################################################################################

reposync -p /var/lib/repo/yum/centos/7 --repoid=openstack-kilo
createrepo /var/lib/repo/yum/centos/7/openstack-kilo

####################################################################################
### CentOS 7 - Scality Lorien
####################################################################################

#reposync -p /var/lib/repo/yum/centos/7/scality-lorien/x86_64 --repoid=scality-lorien-centos7 --norepopath
#createrepo /var/lib/repo/yum/centos/7/scality-lorien/x86_64

