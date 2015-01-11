
##exit

### CentOS 6

mkdir -p /var/yum/repo/centos/6/os
mkdir -p /var/yum/repo/centos/6/updates
mkdir -p /var/yum/repo/centos/6/extras

cd /var/yum/repo/centos/6

rsync -avrt rsync://mirror.umd.edu/centos/6/os .
rsync -avrt rsync://mirror.umd.edu/centos/6/updates .
rsync -avrt rsync://mirror.umd.edu/centos/6/extras .

### CentOS 7

mkdir -p /var/yum/repo/centos/7/os
mkdir -p /var/yum/repo/centos/7/updates
mkdir -p /var/yum/repo/centos/7/extras
mkdir -p /var/yum/repo/centos/7/epel
mkdir -p /var/yum/repo/centos/7/openstack-juno

cd /var/yum/repo/centos/7

rsync -avrt rsync://mirror.umd.edu/centos/7/os .
rsync -avrt rsync://mirror.umd.edu/centos/7/updates .
rsync -avrt rsync://mirror.umd.edu/centos/7/extras .

reposync -p /var/yum/repo/centos/7 --repoid=epel
reposync -p /var/yum/repo/centos/7 --repoid=openstack-juno

createrepo /var/yum/repo/centos/7/epel
createrepo /var/yum/repo/centos/7/openstack-juno

