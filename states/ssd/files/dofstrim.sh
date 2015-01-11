#!/bin/sh

echo "dofstrim started `date`"

# this cronjob will discard unused blocks on the ssd mounted filesystems

# get the locally mounted block devices - those starting with "/dev:
# run df -k, pipe the result through grep and save the sixth field in
# in the mountpoint array
mountpoint=( $(df -k | grep ^/dev | awk '{print $6}') )

# loop through the array and run fstrim on every mountpoint
for i in "${mountpoint[@]}"
do
echo "trimming $i"
/usr/sbin/fstrim -v $i;
done

echo "dofstrim finished  `date`"

