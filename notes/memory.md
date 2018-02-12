
### Memory
`

#### Clear RAM Memory Cache, Buffer and Swap Space on Linux

- Clear PageCache only: `sync; echo 1 > /proc/sys/vm/drop_caches`
- Clear dentries and inodes: `sync; echo 2 > /proc/sys/vm/drop_caches`
- Clear PageCache, dentries and inodes: `sync; echo 3 > /proc/sys/vm/drop_caches`

```
ps -eo size,pid,user,command --sort -size | awk '{ hr=$1/1024 ; printf("%13.2f Mb ",hr) } { for ( x=4 ; x<=NF ; x++ ) { printf("%s ",$x) } print "" }' |cut -d "" -f2 | cut -d "-" -f1|head -30
```

### References

- [How to Clear RAM Memory Cache, Buffer and Swap Space on Linux](https://www.tecmint.com/clear-ram-memory-cache-buffer-and-swap-space-on-linux/)
- [Linux Ate My RAM](https://www.linuxatemyram.com/)
