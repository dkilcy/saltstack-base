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
        mkfs.ext4 ${DEV}1
        tune2fs -m0 -c0 -C0 -i0 ${DEV}1
        parted ${DEV} print
done

UUID=`blkid | grep /dev/sdb1 | awk {'print $2'}`; echo "${UUID} /data ext4 noatime,data=ordered,barrier=1,discard 0 0" >> /etc/fstab
mkdir -p /data
mount /data
