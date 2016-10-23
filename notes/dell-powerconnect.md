
### Dell PowerConnect 6224 Switch

#### Connect to the console

1. Turn on the switch
2. Connect to the console: `minicom -D /dev/ttyUSB0 -b 9600`
3. Hit Enter.  The `console>` prompt appears.  

- Superuser access: `enable`
- Save the running config: `copy running-config startup-config`

#### Set the IP address of the switch 

```
enable
configure
ip address none
ip address 10.0.0.226 255.255.255.0
ip default-gateway 10.0.0.1
exit
show ip interface management
```

#### Update the Firmware from 2.x to 3.x

1. Verify switch status is OK: `show switch`
2. Disable persistent logging

```
config
no logging file
```

3. Shut down all ports except for 24

```
config
interface range ethernet all
shutdown
exit
interface ethernet 1/g24
no shutdown
exit
exit
```

4. Load the software onto the system

```
console#copy tftp://10.0.0.6/PC6200v3.3.14.2.stk image


Mode........................................... TFTP  
Set TFTP Server IP............................. 10.0.0.6
TFTP Path...................................... ./
TFTP Filename.................................. PC6200v3.3.14.2.stk
Data Type...................................... Code            
Destination Filename........................... image

Management access will be blocked for the duration of the transfer
Are you sure you want to start? (y/n) y


TFTP code transfer starting

9732180 bytes transferred    

Verifying CRC of file in Flash File System


Unpacking the image file.

TFTP download successful. All units updated code.


File transfer operation completed successfully.

console#show version

Image Descriptions 

 image1 : Factory Default 
 image2 : V 2.2.0.3-14 


 Images currently available on Flash 

--------------------------------------------------------------------
 unit      image1      image2     current-active        next-active 
-------------------------------------------------------------------- 

    1     2.2.0.3    3.3.14.2             image1             image1 

console#boot system image2
Activating image image2 ..

console#show version

Image Descriptions 

 image1 : Factory Default 
 image2 : V 2.2.0.3-14 


 Images currently available on Flash 

--------------------------------------------------------------------
 unit      image1      image2     current-active        next-active 
-------------------------------------------------------------------- 

    1     2.2.0.3    3.3.14.2             image1             image2 


console#reload

Management switch has unsaved changes.
Are you sure you want to continue? (y/n) y

Configuration Not Saved!
Are you sure you want to reload the stack? (y/n) y


Reloading all switches.

Boot Menu Version: 21 November 2008
...
Boot Menu Version: 21 November 2008
Select an option. If no selection in 10 seconds then
operational code will start.

1 - Start operational code.
2 - Start Boot Menu.
Select (1, 2):2



Boot Menu 21 November 2008

Options available
1  - Start operational code
2  - Change baud rate
3  - Retrieve event log using XMODEM
4  - Load new operational code using XMODEM
5  - Display operational code vital product data
6  - Reserved
7  - Update boot code
8  - Delete backup image
9  - Reset the system
10 - Restore configuration to factory defaults (delete config files)
11 - Activate Backup Image
12 - Password Recovery Procedure
[Boot Menu] 7
Do you wish to update Boot Code and reset the switch? (y/n) y

```

#### Set MTU to 9000 (9216)

```
enable
configure
interface range ethernet all
mtu 9216
exit
```

#### Change stack ports from "ethernet" to "stack"

Stack ports need to be in "stack" mode in order for stacking to work.

```
config
stack 
stack-port 1/xg1 stack
stack-port 1/xg2 stack
```

- Reboot the switch

#### References

- [How to configure the optimal switch settings for an IP based SAN](http://en.community.dell.com/techcenter/enterprise-solutions/w/oracle_solutions/1422.how-to-configure-the-optimal-switch-settings-for-an-ip-based-san)
- [PowerConnect Common Example Commands](http://en.community.dell.com/support-forums/network-switches/f/866/t/19445143)
- [Firmware](http://www.dell.com/support/home/us/en/04/product-support/product/powerconnect-6224/drivers)
- [Stacking switches](http://www.dell.com/downloads/global/products/pwcnt/en/pwcnt_stacking_switches.pdf)
- [Factory Reset](http://dcomcomputers.blogspot.com/2013/09/how-to-factory-default-and-test-ports.html)
- [MTU Oversize Packages](http://en.community.dell.com/techcenter/networking/f/4454/t/19415314)
- [MTU and VLANs](http://en.community.dell.com/support-forums/network-switches/f/866/t/19602268)
- [MTU and ESX](http://www.penguinpunk.net/blog/dell-powerconnect-and-jumbo-frames/)
- [Configuring Stacking on Dell 6248 Switches](http://www.seanlabrie.com/2011/configuring-stacking-on-dell-6248-switches/)

