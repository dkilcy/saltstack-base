
##exit

####################################################################################
### CentOS 6
####################################################################################

mkdir -p /var/www/html/repo/centos/6/os
mkdir -p /var/www/html/repo/centos/6/updates
mkdir -p /var/www/html/repo/centos/6/extras

cd /var/www/html/repo/centos/6

rsync -avrt --exclude 'i386*' --exclude 'debug' rsync://mirror.umd.edu/centos/6/os .
rsync -avrt --exclude 'i386*' --exclude 'debug' rsync://mirror.umd.edu/centos/6/updates .
rsync -avrt --exclude 'i386*' --exclude 'debug' rsync://mirror.umd.edu/centos/6/extras .

####################################################################################
### CentOS 6 - EPEL 
####################################################################################

mkdir -p /var/www/html/repo/centos/6/epel

cd /var/www/html/repo/centos/6/epel

#rsync -avrt rsync://mirror.pnl.gov/epel/6/i386 .
rsync -avrt --exclude 'debug' rsync://mirror.pnl.gov/epel/6/x86_64 .

####################################################################################
### CentOS 6 - Scality Lorien
####################################################################################

reposync -p /var/www/html/repo/centos/6/scality-lorien/x86_64 --repoid=scality-lorien-centos6 --norepopath
createrepo /var/www/html/repo/centos/6/scality-lorien/x86_6

reposync -p /var/www/html/repo/centos/6/scality-lorien1/x86_64 --repoid=scality-lorien1-centos6 --norepopath
createrepo /var/www/html/repo/centos/6/scality-lorien1/x86_64


####################################################################################
### CentOS 7
####################################################################################

mkdir -p /var/www/html/repo/centos/7/os
mkdir -p /var/www/html/repo/centos/7/updates
mkdir -p /var/www/html/repo/centos/7/extras

cd /var/www/html/repo/centos/7

rsync -avrt --exclude 'debug' rsync://mirror.umd.edu/centos/7/os .
rsync -avrt --exclude 'debug' rsync://mirror.umd.edu/centos/7/updates .
rsync -avrt --exclude 'debug' rsync://mirror.umd.edu/centos/7/extras .

####################################################################################
### CentOS 7 - EPEL
####################################################################################

mkdir -p /var/www/html/repo/centos/7/epel
cd /var/www/html/repo/centos/7/epel
rsync -avrt --exclude 'debug' rsync://mirror.pnl.gov/epel/7/x86_64 .

####################################################################################

####################################################################################
### CentOS 7 - Openstack Kilo
####################################################################################

reposync -p /var/www/html/repo/centos/7 --repoid=openstack-kilo
createrepo /var/www/html/repo/centos/7/openstack-kilo

####################################################################################
### CentOS 7 - Scality Lorien
####################################################################################

reposync -p /var/www/html/repo/centos/7/scality-lorien1/x86_64 --repoid=scality-lorien1-centos7 --norepopath
createrepo /var/www/html/repo/centos/7/scality-lorien1/x86_64

