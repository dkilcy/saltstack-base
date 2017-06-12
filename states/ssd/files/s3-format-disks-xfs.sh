#!/bin/bash

umount /scality-s3

dd if=/dev/zero of=/dev/sdb bs=1M count=512

###rm -Rf /scality

sed -i "/scality/d" /etc/fstab
sed -i "/SCALITY/d" /etc/fstab

#exit

for DEV in /dev/sdb
do
        echo $DEV
        parted ${DEV} mklabel gpt -s
        parted ${DEV} mkpart primary 2048s 100% -s
        parted ${DEV} align-check optimal 1
        mkfs.xfs -f -L /scality-s3 -d agcount=64 -l size=128m,version=2 ${DEV}1
        parted ${DEV} print
done

# Add nobarrier for battery-backed RAID controller 
UUID=`blkid | grep /dev/sdb1 | awk {'print $3'}`; echo "${UUID} /scality-s3 xfs rw,noatime,logbufs=8,logbsize=256k,inode64 0 0" >> /etc/fstab

mkdir -p /scality-s3

mount /scality-s3

