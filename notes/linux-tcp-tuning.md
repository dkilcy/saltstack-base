

### Linux TCP Tuning

- Check Ring Buffer Size

```
[root@HSEDL-CHF01-01V dkilcy]# ethtool -g eth7
Ring parameters for eth7:
Pre-set maximums:
RX:             4096
RX Mini:        0
RX Jumbo:       4096
TX:             4096
Current hardware settings:
RX:             256
RX Mini:        0
RX Jumbo:       128
TX:             512
```

```
18-02-08T11:17:12 root@hsepl-srs3-01 ~]# ethtool -g em1
Ring parameters for em1:
Pre-set maximums:
RX:             4078
RX Mini:        0
RX Jumbo:       0
TX:             4078
Current hardware settings:
RX:             453
RX Mini:        0
RX Jumbo:       0
TX:             4078

18-02-08T11:17:17 root@hsepl-srs3-01 ~]# ethtool -g em2
Ring parameters for em2:
Pre-set maximums:
RX:             4078
RX Mini:        0
RX Jumbo:       0
TX:             4078
Current hardware settings:
RX:             453
RX Mini:        0
RX Jumbo:       0
TX:             4078

```

### References

- [https://www.cyberciti.biz/faq/linux-tcp-tuning/](https://www.cyberciti.biz/faq/linux-tcp-tuning/)
-
