
pxeserver_pkgs:
  pkg.installed:
    - pkgs:
      - dhcp
      - httpd
      - syslinux
      - tftp-server
      - vsftpd

/var/www/html/repo:
  file.directory:
    - target: /var/www/html/repo

/etc/dhcp/dhcpd.conf:
  file.managed:
    - name: /etc/dhcp/dhcpd.conf
    - source: salt://pxeserver/files/dhcpd.conf
    - template: jinja
    
copy_bootloaders:
  cmd.run:
    - name: cp -r /usr/share/syslinux/* /var/lib/tftpboot/

pxelinux_default:
  file.managed:
    - name: /var/lib/tftpboot/pxelinux.cfg/default
    - source: salt://pxeserver/files/pxelinux.cfg.default
    - makedirs: True

/var/lib/tftpboot/centos/7:
  file.directory:
    - name: /var/ftp/tftpboot/centos/7
    - makedirs: True

/var/lib/tftpboot/centos/7/initrd.img:
  file.managed:
    - name: /var/ftp/tftpboot/centos/7/initrd.img
    - source: /var/tmp/iso/centos/7/initrd.img

/var/lib/tftpboot/centos/7/vmlinuz:
  file.managed:
    - name: /var/ftp/tftpboot/centos/7/vmlinuz
    - source: /var/tmp/iso/centos/7/vmlinuz

/var/lib/tftpboot/centos/6:
  file.directory:
    - name: /var/ftp/tftpboot/centos/6
    - makedirs: True

/var/lib/tftpboot/centos/6/initrd.img:
  file.managed:
    - name: /var/ftp/tftpboot/centos/6/initrd.img
    - source: /var/tmp/iso/centos/6/initrd.img

/var/lib/tftpboot/centos/6/vmlinuz:
  file.managed:
    - name: /var/ftp/tftpboot/centos/6/vmlinuz
    - source: /var/tmp/iso/centos/6/vmlinuz

/var/ftp/pub/centos/7:
  file.directory:
    - name: /var/ftp/pub/centos/7
    - makedirs: True
  mount.mounted:
    - device: /var/tmp/iso/centos/7/CentOS-7-x86_64-Everything-1511.iso
    - opts: loop,ro
    - mkmnt: True
    - persist: True
    - fstype: iso9660

/var/ftp/pub/centos/6:
  file.directory:
    - name: /var/ftp/pub/centos/6
    - makedirs: True
  mount.mounted:
    - device: /var/tmp/iso/centos/6/CentOS-6.7-x86_64-bin-DVD1.iso
    - opts: loop,ro
    - mkmnt: True
    - persist: True
    - fstype: iso9660

reposync.sh:
  file.managed:
    - name: /usr/local/bin/reposync.sh
    - source: salt://pxeserver/files/reposync.sh
    - mode: 755

pxeserver_httpd_service:
  service.running:
    - name: httpd
    - enable: True
  require:
    - file: /var/www/html/repo

dhcp_service:
  service.running:
    - name: dhcpd
    - enable: True
    - reload: True
    - watch:
      - file: /etc/dhcp/dhcpd.conf

vsftpd_service:
  service.running:
    - name: vsftpd
    - enable: True

/etc/xinetd.d/tftp:
  file.managed:
    - name: /etc/xinetd.d/tftp
    - source: salt://pxeserver/files/tftp

xinetd_service:
  service.running:
    - name: xinetd
    - enable: True
    - require:
      - file: /etc/xinetd.d/tftp

