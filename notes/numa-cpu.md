#### Cacheline

True Sharing/False Sharing:
* True Sharing: 2 threads modifying the same memory location (ex: lock)
* False Sharing: 2 threads accessing different location in same cache line

True/False sharing really hurts performance when sharing is across NUMA nodes.

How to diagnose:
* numastat 
* perf
* perf mem-loads (3.10 kernel)
* c2c data-sharing (with perf in future)

numastat -mczs <process name>
numactl - can pin a process to a specific numa node

At a high level do I have my CPUs and memory pinned OK? Try numastat.

Checking the cpu-pinning:
Where are the pids allowed to run?
/proc/<pid>/status file(s)

Now can we determine what NUMA nodes each CPU belongs to?
```
numactl --hardware | grep cpus
```
We know know:
- The majority of memory is pinned to the desired nodes
- the CPUs are pinned to the nodes where the memory resides

However we dont know:
If any processes are accesing memory on a remote NUMA node
If so, then:
- Are they contending with other processes for any cachelines?
- What CPUs are they running on
- What are their PIDs and TIDs
- What are the remote data addresses being accessed?
- Where in the application those accesses are occurring (the instruction pointer)?
- Are they reading or modifying the cachelines - and how often?

#### References
- [Processor Affinity](http://www.glennklockwood.com/comp/affinity.php)
