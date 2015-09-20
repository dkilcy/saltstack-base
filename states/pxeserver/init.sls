
pxeserver_pkgs:
  pkg.installed:
    - pkgs:
      - dhcp
      - httpd
      - syslinux
      - tftp-server
      - vsftpd

/var/tmp/iso:
  file.directory:
    - name: /var/tmp/repo

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

/var/ftp/pub/centos/7:
  file.directory:
    - name: /var/ftp/pub/centos/7
    - makedirs: True
  mount.mounted:
    - device: /var/tmp/iso/CentOS-7-x86_64-Everything-1503-01.iso
    - opts: loop,ro
    - mkmnt: True
    - persist: True
    - fstype: iso9660

/var/ftp/pub/centos/6:
  file.directory:
    - name: /var/ftp/pub/centos/6
    - makedirs: True
  mount.mounted:
    - device: /var/tmp/iso/CentOS-6.6-x86_64-bin-DVD1.iso
    - opts: loop,ro
    - mkmnt: True
    - persist: True
    - fstype: iso9660


/var/lib/tftpboot/centos7:
  file.directory:
    - name: /var/lib/tftpboot/centos7
    - makedirs: True

/var/lib/tftpboot/centos6:
  file.directory:
    - name: /var/lib/tftpboot/centos6
    - makedirs: True

/var/lib/tftpboot/centos7/vmlinuz:
  file.copy:
    - name: /var/lib/tftpboot/centos7/vmlinuz
    - source: /var/ftp/pub/centos/7/images/pxeboot/vmlinuz

/var/lib/tftpboot/centos7/initrd.img:
  file.copy:
    - name: /var/lib/tftpboot/centos7/initrd.img
    - source: /var/ftp/pub/centos/7/images/pxeboot/initrd.img

/var/lib/tftpboot/centos6/vmlinuz:
  file.copy:
    - name: /var/lib/tftpboot/centos6/vmlinuz
    - source: /var/ftp/pub/centos/6/images/pxeboot/vmlinuz

/var/lib/tftpboot/centos6/initrd.img:
  file.copy:
    - name: /var/lib/tftpboot/centos6/initrd.img
    - source: /var/ftp/pub/centos/6/images/pxeboot/initrd.img

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

