
cpupower:
  cmd.run:
    - name: '/bin/cpupower frequency-set --governor performance'

  file.append:
    - name: /etc/rc.d/rc.local
    - text:
      - 'cpupower frequency-set --governor performance'

