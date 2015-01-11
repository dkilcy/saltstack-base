
ntp:
  pkg.installed:
    - name: ntp

ntpd:
  service.running:
    - enable: True
    - watch:
      - file: /etc/ntp.conf

  file.managed:
    - name: /etc/ntp.conf
    - source: salt://ntp/ntp.conf
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: ntp
