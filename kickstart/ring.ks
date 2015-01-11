#version=RHEL7

eula --agreed

# the Setup Agent is not started the first time the system boots
firstboot --disable

# text mode (no graphical mode)
text
# do not configure X
skipx
# non-interactive command line mode
cmdline
# install
install

# network
network --bootproto=dhcp --device=enp0s20f0 --noipv6 --onboot=yes --mtu=9000 --activate
network --bootproto=static --device=enp0s20f1 --noipv6 --onboot=no
network --bootproto=static --device=enp0s20f2 --noipv6 --onboot=no
network --bootproto=static --device=enp0s20f3 --noipv6 --onboot=no

# installation path
url --url=http://10.0.0.6/repo/centos/7/os/x86_64
# repository
repo --name="CentOS Base"   --baseurl=http://10.0.0.6/repo/centos/7/os/x86_64
repo --name="CentOS Update" --baseurl=http://10.0.0.6/repo/centos/7/updates/x86_64
repo --name="EPEL"          --baseurl=http://10.0.0.6/repo/centos/7/epel

# Keyboard layouts
keyboard --vckeymap=us --xlayouts='us'
# System language
lang en_US.UTF-8
# timezone
timezone --utc UTC

# root password
rootpw scality
# System authorization information
auth --enableshadow --passalgo=sha512

# SElinux
selinux --disabled
# firewall
firewall --disabled

# bootloader
bootloader --location=mbr --boot-drive=sda
# clear the MBR (Master Boot Record)
zerombr
# do not remove any partition (preserve the gpt label)
#clearpart --none
clearpart --all
#ignoredisk --drives=sda

# Disk partitioning information
part /boot --fstype="ext4" --ondisk=sda --size=512 --fsoptions=rw,noatime,nodiratime
part swap --fstype="swap" --ondisk=sda --size=4096
part / --fstype="ext4" --ondisk=sda --size=1 --grow --fsoptions=rw,noatime,nodiratime

part /scality/disk1 --fstype="ext4" --ondisk=sdb --size=1 --grow --fsoptions=rw,noatime,nodiratime
part /scality/disk2 --fstype="ext4" --ondisk=sdc --size=1 --grow --fsoptions=rw,noatime,nodiratime

# Reboot
reboot --eject

################################################################################
#%pre
#parted -s /dev/sdb mklabel gpt
#parted -s -a optimal /dev/sdc mklabel gpt
#parted -s -a optimal /dev/sdd mklabel gpt
#%end
################################################################################
%packages --nobase --ignoremissing
@core
dstat
#epel-release
#git
hdparm
htop
iotop
iperf3
keyutils
lshw
net-snmp
net-snmp-libs
net-snmp-perl.x86_64
net-snmp-utils.x86_64
#ntp
openssh-clients
parted
pciutils
rsync
salt-minion
screen
tcpdump
telnet
traceroute
vim-enhanced
wget
yum-utils
zip
%end
################################################################################
%post
KS_URL=http://10.0.0.6

curl $KS_URL/hosts > /etc/hosts
# Based on the IP address returned from the DHCP server, lookup the 
# hostname in /etc/hosts and set it
IP=`ip a show enp0s20f0 | grep 'inet ' | awk '{print $2}' | cut -f1 -d '/'`
HOSTNAME=`grep $IP /etc/hosts | awk '{print $3}'`
echo $HOSTNAME > /etc/hostname
hostname $HOSTNAME

# Use the local mirror
#for i in /etc/yum.repos.d/*; do mv $i $i.orig; done
#curl $KS_URL/local.repo > /etc/yum.repos.d/local.repo

yum -y clean all
yum -y update

echo $HOSTNAME > /etc/salt/minion_id
systemctl enable salt-minion.service

%end
################################################################################
