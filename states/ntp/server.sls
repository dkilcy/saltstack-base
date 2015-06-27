
ntp:
  pkg.installed:
    - name: ntp

ntpd:
  service.running:
    - enable: True

