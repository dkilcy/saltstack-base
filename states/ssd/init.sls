
ssd_trim:
  file.managed:
    - name: /usr/local/bin/dofstrim.sh
    - source: salt://ssd/files/dofstrim.sh
    - user: root
    - group: root
    - mode: 755

