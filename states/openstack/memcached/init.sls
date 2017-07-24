
memcached-pkgs:
  pkg.installed:
    - pkgs:
      - memcached
      - python-memcached

/etc/sysconfig/memcached:
  file.replace:
    - pattern: 'OPTIONS="-l 127.0.0.1,::1"'
    - repl: 'OPTIONS="-l 127.0.0.1,{{ salt['grains.get']('fqdn_ip4:0') }}"'

memcached-service:
  service.running:
    - name: memcached
    - enable: True
    - watch:
      - file: /etc/sysconfig/memcached

