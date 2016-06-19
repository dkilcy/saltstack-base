
### Dell PowerConnect 6224 Switch

#### Connect to the console

1. Turn on the switch
2. Connect to the console: `minicom -D /dev/ttyUSB0 -b 9600`
3. Hit Enter.  The `console>` prompt appears.  

Execute `enable` for superuser access
To save the running config: `console# copy running-config startup-config`

#### Set the IP address of the switch 

```
configure
ip address none
ip address 10.0.0.241 255.255.255.0
ip default-gateway 10.0.0.1
exit
show ip interface management
```

#### Set MTU to 9000 (9216)

```
console# configure

console(config)# interface range ethernet all

console(config-if)# mtu 9216

console(config-if)# exit

console(config)# exit

console# copy running-config startup-config

console# exit
```

#### References

- [Firmware](http://www.dell.com/support/home/us/en/04/product-support/product/powerconnect-6224/drivers)
- [Stacking switches](http://www.dell.com/downloads/global/products/pwcnt/en/pwcnt_stacking_switches.pdf)
- [Factory Reset](http://dcomcomputers.blogspot.com/2013/09/how-to-factory-default-and-test-ports.html)
- [MTU Oversize Packages](http://en.community.dell.com/techcenter/networking/f/4454/t/19415314)
- [MTU and VLANs](http://en.community.dell.com/support-forums/network-switches/f/866/t/19602268)
- [MTU and ESX](http://www.penguinpunk.net/blog/dell-powerconnect-and-jumbo-frames/)

