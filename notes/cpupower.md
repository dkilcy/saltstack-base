

### Turn off CPU frequency governor on CentOS 7

Change the frequency governor from **ondemand** to **performance**

View current frequency info
```
$ cpupower frequency-info
analyzing CPU 0:
  driver: acpi-cpufreq
  CPUs which run at the same hardware frequency: 0
  CPUs which need to have their frequency coordinated by software: 0
  maximum transition latency: 10.0 us.
  hardware limits: 1.20 GHz - 2.40 GHz
  available frequency steps: 2.40 GHz, 2.30 GHz, 2.20 GHz, 2.10 GHz, 2.00 GHz, 1.90 GHz, 1.80 GHz, 1.70 GHz, 1.60 GHz, 1.50 GHz, 1.40 GHz, 1.30 GHz, 1.20 GHz
  available cpufreq governors: conservative, userspace, powersave, ondemand, performance
  current policy: frequency should be within 1.20 GHz and 2.40 GHz.
                  The governor "ondemand" may decide which speed to use
                  within this range.
  current CPU frequency is 1.20 GHz (asserted by call to hardware).
  boost state support:
    Supported: no
    Active: no
```

Show the current CPU speed for each core
```
$ grep -E '^model name|^cpu MHz' /proc/cpuinfo
model name	: Intel(R) Atom(TM) CPU  C2758  @ 2.40GHz
cpu MHz		: 2400.000
model name	: Intel(R) Atom(TM) CPU  C2758  @ 2.40GHz
cpu MHz		: 1200.000
model name	: Intel(R) Atom(TM) CPU  C2758  @ 2.40GHz
cpu MHz		: 1200.000
model name	: Intel(R) Atom(TM) CPU  C2758  @ 2.40GHz
cpu MHz		: 1200.000
model name	: Intel(R) Atom(TM) CPU  C2758  @ 2.40GHz
cpu MHz		: 1200.000
model name	: Intel(R) Atom(TM) CPU  C2758  @ 2.40GHz
cpu MHz		: 1200.000
model name	: Intel(R) Atom(TM) CPU  C2758  @ 2.40GHz
cpu MHz		: 1200.000
model name	: Intel(R) Atom(TM) CPU  C2758  @ 2.40GHz
cpu MHz		: 1200.000

```

Set governor policy to **performance**
```
$ cpupower frequency-set --governor performance
Setting cpu: 0
Setting cpu: 1
Setting cpu: 2
Setting cpu: 3
Setting cpu: 4
Setting cpu: 5
Setting cpu: 6
Setting cpu: 7
```

Verify the change
```
$ cpupower frequency-info
analyzing CPU 0:
  driver: acpi-cpufreq
  CPUs which run at the same hardware frequency: 0
  CPUs which need to have their frequency coordinated by software: 0
  maximum transition latency: 10.0 us.
  hardware limits: 1.20 GHz - 2.40 GHz
  available frequency steps: 2.40 GHz, 2.30 GHz, 2.20 GHz, 2.10 GHz, 2.00 GHz, 1.90 GHz, 1.80 GHz, 1.70 GHz, 1.60 GHz, 1.50 GHz, 1.40 GHz, 1.30 GHz, 1.20 GHz
  available cpufreq governors: conservative, userspace, powersave, ondemand, performance
  current policy: frequency should be within 1.20 GHz and 2.40 GHz.
                  The governor "performance" may decide which speed to use
                  within this range.
  current CPU frequency is 2.40 GHz (asserted by call to hardware).
  boost state support:
    Supported: no
    Active: no

$ grep -E '^model name|^cpu MHz' /proc/cpuinfo
model name	: Intel(R) Atom(TM) CPU  C2758  @ 2.40GHz
cpu MHz		: 2400.000
model name	: Intel(R) Atom(TM) CPU  C2758  @ 2.40GHz
cpu MHz		: 2400.000
model name	: Intel(R) Atom(TM) CPU  C2758  @ 2.40GHz
cpu MHz		: 2400.000
model name	: Intel(R) Atom(TM) CPU  C2758  @ 2.40GHz
cpu MHz		: 2400.000
model name	: Intel(R) Atom(TM) CPU  C2758  @ 2.40GHz
cpu MHz		: 2400.000
model name	: Intel(R) Atom(TM) CPU  C2758  @ 2.40GHz
cpu MHz		: 2400.000
model name	: Intel(R) Atom(TM) CPU  C2758  @ 2.40GHz
cpu MHz		: 2400.000
model name	: Intel(R) Atom(TM) CPU  C2758  @ 2.40GHz
cpu MHz		: 2400.000
```

##### References

- [http://unix.stackexchange.com/questions/77410/centos-conservative-governor-nice-error](http://unix.stackexchange.com/questions/77410/centos-conservative-governor-nice-error)
- [http://www.servernoobs.com/avoiding-cpu-speed-scaling-in-modern-linux-distributions-running-cpu-at-full-speed-tips/](http://www.servernoobs.com/avoiding-cpu-speed-scaling-in-modern-linux-distributions-running-cpu-at-full-speed-tips/)

