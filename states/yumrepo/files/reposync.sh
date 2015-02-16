
##exit

### CentOS 6

mkdir -p /var/repo/yum/centos/6/os
mkdir -p /var/repo/yum/centos/6/updates
mkdir -p /var/repo/yum/centos/6/extras

cd /var/repo/yum/centos/6

rsync -avrt rsync://mirror.umd.edu/centos/6/os .
rsync -avrt rsync://mirror.umd.edu/centos/6/updates .
rsync -avrt rsync://mirror.umd.edu/centos/6/extras .

cd /var/repo/yum/centos/6/epel
rsync -avrt rsync://mirror.pnl.gov/epel/6/i386 .
rsync -avrt rsync://mirror.pnl.gov/epel/6/x86_64 .


### CentOS 7

mkdir -p /var/repo/yum/centos/7/os
mkdir -p /var/repo/yum/centos/7/updates
mkdir -p /var/repo/yum/centos/7/extras
mkdir -p /var/repo/yum/centos/7/epel
mkdir -p /var/repo/yum/centos/7/openstack-juno

cd /var/repo/yum/centos/7

rsync -avrt rsync://mirror.umd.edu/centos/7/os .
rsync -avrt rsync://mirror.umd.edu/centos/7/updates .
rsync -avrt rsync://mirror.umd.edu/centos/7/extras .

reposync -p /var/repo/yum/centos/7 --repoid=epel
reposync -p /var/repo/yum/centos/7 --repoid=openstack-juno

createrepo /var/repo/yum/centos/7/epel
createrepo /var/repo/yum/centos/7/openstack-juno

