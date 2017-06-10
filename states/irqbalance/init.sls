

/etc/sysconfig/irqbalance:
  file.replace:
    - pattern: '#IRQBALANCE_ONESHOT='
    - repl: 'IRQBALANCE_ONESHOT=on'

irqbalance_service:
  service.running:
    - name: irqbalance
    - enable: True
    - watch:
      - file: /etc/sysconfig/irqbalance


