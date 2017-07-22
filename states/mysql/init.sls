{% from "mysql/map.jinja" import mysql with context %}

mysql-server:

  pkg.installed:
    - pkgs:
      - {{ mysql.client }}
      - {{ mysql.server }}
      - {{ mysql.python }}

  file.managed:
    - name: {{ mysql.config }}
    - mode: 644
    - user: root
    - group: root
#    - require:
#      - pkg: {{ mysql.server }}
    - contents: |
        [mysqld]
        bind-address = 0.0.0.0
        default-storage-engine = innodb
        innodb_file_per_table = on
        max_connections = 4096
        collation-server = utf8_general_ci
        character-set-server = utf8

  service.running:
    - name: {{ mysql.service }}
    - enable: True
#    - require:
#      - pkg: {{ mysql.server }}

  mysql_user.present:
    - name: root
    - host: localhost
    - password: {{ salt['pillar.get']('mysql:root_pass') }}
    - password_hash: '*'
    - require:
      - service: {{ mysql.service }}

