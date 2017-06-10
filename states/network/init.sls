
/etc/hosts:
  file.managed:
    - name: /etc/hosts
    - source: salt://network/files/hosts
    - replace: True

/usr/local/bin/set-irq-affinity.sh:
  file.managed:
    - name: /usr/local/bin/seti-irq-affinity.sh
    - source: salt://network/files/set-irq-affinity.sh
    - replace: True
    - mode: 755

