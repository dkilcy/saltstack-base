
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


