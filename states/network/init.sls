
/etc/hosts:
  file.managed:
    - name: /etc/hosts
    - source: salt://network/files/hosts
    - replace: True

