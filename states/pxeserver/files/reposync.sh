
##exit

####################################################################################
### CentOS 6
####################################################################################

mkdir -p /var/www/html/repo/centos/6/os
mkdir -p /var/www/html/repo/centos/6/updates
mkdir -p /var/www/html/repo/centos/6/extras

cd /var/www/html/repo/centos/6

rsync -avrt --delete --exclude 'i386*' --exclude 'debug' --exclude 'drpms' rsync://mirror.umd.edu/centos/6/os .
rsync -avrt --delete --exclude 'i386*' --exclude 'debug' --exclude 'drpms' rsync://mirror.umd.edu/centos/6/updates .
rsync -avrt --delete --exclude 'i386*' --exclude 'debug' --exclude 'drpms' rsync://mirror.umd.edu/centos/6/extras .

####################################################################################
### CentOS 6 - EPEL 
####################################################################################

mkdir -p /var/www/html/repo/centos/6/epel

cd /var/www/html/repo/centos/6/epel

#rsync -avrt rsync://mirror.pnl.gov/epel/6/i386 .
rsync -avrt --delete --exclude 'debug' --exclude 'drpms' rsync://mirror.pnl.gov/epel/6/x86_64 .

####################################################################################
### CentOS 6 - Scality Mithrandir
####################################################################################

reposync -p /var/www/html/repo/centos/6/scality-mithrandir/x86_64 --repoid=scality-mithrandir-centos6 --norepopath
createrepo /var/www/html/repo/centos/6/scality-mithrandir/x86_64

####################################################################################
### CentOS 6 - Scality Numendil 7.X
####################################################################################

reposync -p /var/www/html/repo/centos/6/scality-numendil/x86_64 --repoid=scality-numendil-centos6 --norepopath
createrepo /var/www/html/repo/centos/6/scality-numendil/x86_64

####################################################################################
### CentOS 7
####################################################################################

mkdir -p /var/www/html/repo/centos/7/os
mkdir -p /var/www/html/repo/centos/7/updates
mkdir -p /var/www/html/repo/centos/7/extras

cd /var/www/html/repo/centos/7

rsync -avrt --delete --exclude 'debug' --exclude 'drpms' rsync://mirror.umd.edu/centos/7/os .
rsync -avrt --delete --exclude 'debug' --exclude 'drpms' rsync://mirror.umd.edu/centos/7/updates .
rsync -avrt --delete --exclude 'debug' --exclude 'drpms' rsync://mirror.umd.edu/centos/7/extras .

####################################################################################
### CentOS 7 - EPEL
####################################################################################

mkdir -p /var/www/html/repo/centos/7/epel
cd /var/www/html/repo/centos/7/epel
rsync -avrt --delete --exclude 'debug'  --exclude 'drpms' rsync://mirror.pnl.gov/epel/7/x86_64 .

####################################################################################
### CentOS 7 - Scality Mithrandir 6.X
####################################################################################

reposync -p /var/www/html/repo/centos/7/scality-mithrandir/x86_64 --repoid=scality-mithrandir-centos7 --norepopath
createrepo /var/www/html/repo/centos/7/scality-mithrandir/x86_64

####################################################################################
### CentOS 7 - Scality Numendil 7.X
####################################################################################

reposync -p /var/www/html/repo/centos/7/scality-numendil/x86_64 --repoid=scality-numendil-centos7 --norepopath
createrepo /var/www/html/repo/centos/7/scality-numendil/x86_64

####################################################################################
### OpenStack Liberty
####################################################################################

#reposync -p /var/www/html/repo/centos/7 --repoid=centos-openstack-liberty
#createrepo /var/www/html/repo/centos/7/centos-openstack-liberty

####################################################################################
### Docker
####################################################################################

#reposync -p /var/www/html/repo/centos/7 --repoid=dockerrepo
#createrepo  /var/www/html/repo/centos/7/dockerrepo

####################################################################################
### NodeJS
####################################################################################

#reposync -p /var/www/html/repo/centos/7 --repoid=nodesource
#createrepo  /var/www/html/repo/centos/7/nodesource

####################################################################################
### Saltstack
####################################################################################

reposync -p /var/www/html/repo/redhat/7/saltstack/latest --repoid=saltstack-repo --norepopath
createrepo  /var/www/html/repo/redhat/7/saltstack/latest

####################################################################################

chown -R root.root /var/www/html/repo/*

####################################################################################
# 
# rsync to USB stick:
#
# $ mount /dev/sdb1 /mnt
# $ rsync -avt --delete /var/www/html/repo/ /mnt/repo
#
# rsync the to another system:
#
# $ rsync -avtz --delete /var/www/html/repo/ workstation1:/var/www/html/repo
#
####################################################################################
