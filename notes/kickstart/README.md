#### Create USB stick with CentOS 7 Network Install image

1. Copy the contents of the ISO to a directory
```
mkdir centos-7-netinstall
cd centos-7-netinstall/
cp /var/sw/images/CentOS-7.0-1406-x86_64-NetInstall.iso .
mkdir in out
mount -o loop CentOS-7.0-1406-x86_64-NetInstall.iso in
cp -rT in/ out/
```

2. Modify the contents of the original ISO to load the kickstart configuration

- Copy the kickstart file to ./out as ks.cfg
- Edit the `isolinux/isolinux.cfg` file and do the following:
    - Add `inst.ks=hd:sda1:/ks.cfg` to the **append** entry for the `label linux` entry. 
    - Remove the `quiet` option.
    - Update the menu label 
    - Save the file

3. Create the new ISO image

```
chmod 664 isolinux/isolinux.bin
```
TODO: figure out correct mkisofs command for USB stick....

4. Burn the image to USB stick

```
#dd if=/dev/zero of=/dev/sdb bs=4096 count=512
#below works with DVD or NetInstall image, not any others...
#dd if=CentOS-7.0-1406-x86_64-NetInstall-ks.iso of=/dev/sdb bs=4096
```

#### Create a bootable CentOS 7 minimal image with custom kickstart configuration

1. Copy the contents of the ISO to a directory
```
cd centos7-minimal
cp /data/staging/CentOS-7.0-1406-x86_64-Minimal.iso .
mkdir in out
sudo mount -o loop CentOS-7.0-1406-x86_64-Minimal.iso in
cp -rT in/ out/
```

2. Modify the contents of the original ISO to load the kickstart configuration

- Change to the `out` directory: `cd out`
- Create a directory called `ks` and copy the `ks.cfg` file to this directory

- Edit the `isolinux/isolinux.cfg` file and do the following:
    - Add `inst.ks=cdrom:/dev/cdrom:/ks/ks.cfg` to the **append** entry for the `label linux` entry. 
    - Remove the `quiet` option.
    - Update the menu label 
    - Save the file

3. Create the new ISO image

```
chmod 664 isolinux/isolinux.bin
mkisofs -o ../CentOS-7.0-1406-x86_64-Minimal.2014-11-04-1.iso -b isolinux/isolinux.bin -c isolinux/boot.cat \
  -no-emul-boot -V 'CentOS 7 x86_64' -boot-load-size 4 -boot-info-table -R -J -v -T .
```
4. Burn the image to media and test

#### References

[http://smorgasbork.com/component/content/article/35-linux/151-building-a-custom-centos-7-kickstart-disc-part-1]
