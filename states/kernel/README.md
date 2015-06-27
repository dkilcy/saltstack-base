
### kernel

- List open files: `lsof`
- List kernel parameters: `sysctl -a`
- Show kernel ring buffer: `dmesg | tail`

#### Memory:

- Memory in MB: `free -m`  
- Memory in GB: `free -g`
- Virtual memory stats in MB: `vmstat -S M`  
- Swap space: `swapon -s`  
- Top batch-mode, run once: `top -b -n 1`  
- To free pagecache: `echo 1 > /proc/sys/vm/drop_caches`
- To free dentries and inodes: `echo 2 > /proc/sys/vm/drop_caches`
- To free pagecache, dentries and inodes: `echo 3 > /proc/sys/vm/drop_caches`

#### References

- [https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/7/html/Performance_Tuning_Guide/chap-Red_Hat_Enterprise_Linux-Performance_Tuning_Guide-Storage_and_File_Systems.html#sect-Red_Hat_Enterprise_Linux-Performance_Tuning_Guide-Considerations-Generic_tuning_considerations_for_file_systems](https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/7/html/Performance_Tuning_Guide/chap-Red_Hat_Enterprise_Linux-Performance_Tuning_Guide-Storage_and_File_Systems.html#sect-Red_Hat_Enterprise_Linux-Performance_Tuning_Guide-Considerations-Generic_tuning_considerations_for_file_systems)
- [https://communities.bmc.com/docs/DOC-10204](https://communities.bmc.com/docs/DOC-10204)
- [https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/6/html/Performance_Tuning_Guide/ch04s02s03.html](https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/6/html/Performance_Tuning_Guide/ch04s02s03.html)
- [http://forum.osmc.tv/showthread.php?tid=6825](http://forum.osmc.tv/showthread.php?tid=6825)

