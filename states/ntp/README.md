
### ntp

1. Setup ntpd server on the workstation to be an NTP time server; start and enable the service.

 ```bash
yum install ntp
systemctl start ntpd.service
systemctl enable ntpd.service
```

2. Verify the NTP installation

 ```bash
[root@workstation1 ~]# ntpq -p
     remote           refid      st t when poll reach   delay   offset  jitter
==============================================================================
-y.ns.gin.ntt.ne 198.64.6.114     2 u  465 1024  375   38.859  -14.201   8.438
*ntp.your.org    .CDMA.           1 u  853 1024  377   29.042    1.957   4.626
+www.linas.org   129.250.35.250   3 u  470 1024  377   44.347    1.349   5.194
+ntp3.junkemailf 149.20.64.28     2 u  675 1024  337   78.504    4.305   3.001

[root@workstation1 ~]# ntpq -c assoc

ind assid status  conf reach auth condition  last_event cnt
===========================================================
  1  3548  933a   yes   yes  none   outlyer    sys_peer  3
  2  3549  963a   yes   yes  none  sys.peer    sys_peer  3
  3  3550  9424   yes   yes  none candidate   reachable  2
  4  3551  9424   yes   yes  none candidate   reachable  2
[root@workstation1 ~]# 
```
