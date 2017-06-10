#!/bin/bash

umount /scality/ssd1
umount /scality/ssd2

dd if=/dev/zero of=/dev/sdb bs=1M count=512
dd if=/dev/zero of=/dev/sdc bs=1M count=512

###rm -Rf /scality

sed -i "/scality/d" /etc/fstab
sed -i "/SCALITY/d" /etc/fstab

#exit

for DEV in /dev/sdb /dev/sdc
do
        echo $DEV
        parted ${DEV} mklabel gpt -s
        parted ${DEV} mkpart primary 2048s 100% -s
        parted ${DEV} align-check optimal 1
        mkfs.ext4 ${DEV}1
        tune2fs -m0 -c0 -C0 -i0 ${DEV}1
        parted ${DEV} print
done

UUID=`blkid | grep /dev/sdb1 | awk {'print $2'}`; echo "${UUID} /scality/ssd1 ext4 data=writeback,noauto,noatime,barrier=1,discard 0 0" >> /etc/fstab
UUID=`blkid | grep /dev/sdc1 | awk {'print $2'}`; echo "${UUID} /scality/ssd2 ext4 data=writeback,noauto,noatime,barrier=1,discard 0 0" >> /etc/fstab

mkdir -p /scality/ssd1
mkdir -p /scality/ssd2

mount /scality/ssd1
mount /scality/ssd2

