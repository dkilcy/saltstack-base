
/usr/local/bin/set-irq-affinity.sh:
  file.managed:
    - name: /usr/local/bin/set-irq-affinity.sh
    - source: salt://network/files/set-irq-affinity.sh
    - replace: True
    - mode: 755

