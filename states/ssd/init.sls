
ssd_trim:
  file.managed:
    - name: /usr/local/bin/dofstrim.sh
    - source: salt://ssd/files/dofstrim.sh
    - user: root
    - group: root
    - mode: 755

ssd-cron.daily:
  file.append:
    - name: /etc/crontab
    - text: |
        0 2 * * * /usr/local/bin/dofstrim.sh > /var/log/dofstrim.out 2>&1

scheduler.rules:
  file.managed:
    - name: /etc/udev/rules.d/60-schedulers.rules
    - source: salt://ssd/files/60-schedulers.rules

