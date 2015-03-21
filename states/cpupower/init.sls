
cpupower:
  cmd.run:
    - name: '/bin/cpupower frequency-set --governor performance'

  file.append:
    - name: /etc/rc.d/rc.local
    - text:
      - '/bin/cpupower frequency-set --governor performance'
