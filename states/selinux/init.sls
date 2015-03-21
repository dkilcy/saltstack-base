

/etc/selinux/config:
  file.replace:
    - pattern: 'SELINUX=enforcing'
    - repl: 'SELINUX=disabled'

