### Multimedia 

[http://wiki.centos.org/TipsAndTricks/MultimediaOnCentOS7](http://wiki.centos.org/TipsAndTricks/MultimediaOnCentOS7)

- Audio: `aplay -l` 
    - Test audio: `aplay -D plughw:0,0 /usr/share/sounds/alsa/Front_Center.wav` 

```
# cat /etc/asound.conf 
#
# Place your global alsa-lib configuration here...
#
pcm.!default {
type hw
card 0
device 0
}

```

###### Adobe Flash
```
rpm -ivh http://linuxdownload.adobe.com/adobe-release/adobe-release-x86_64-1.0-1.noarch.rpm
rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-adobe-linux

yum install flash-plugin nspluginwrapper alsa-plugins-pulseaudio libcurl
```

### References:  
- https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/7/html/Installation_Guide/sect-making-usb-media.html#sect-making-usb-media-linux
- http://www.pantz.org/software/parted/
