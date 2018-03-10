#!/bin/bash

#exit

umount /data
dd if=/dev/zero of=/dev/sdb bs=1M count=512
sed -i "/data/d" /etc/fstab

for DEV in /dev/sdb
do
        echo $DEV
        parted ${DEV} mklabel gpt -s
        parted ${DEV} mkpart primary 2048s 100% -s
        parted ${DEV} align-check optimal 1
        mkfs.xfs -f -L /data -d agcount=64 -l size=128m,version=2 ${DEV}1
        parted ${DEV} print
done

UUID=`blkid | grep /dev/sdb1 | awk {'print $3'}`; echo "${UUID} /data xfs rw,noatime,logbufs=8,logbsize=256k,inode64 0 0" >> /etc/fstab
mkdir -p /data
mount /data

