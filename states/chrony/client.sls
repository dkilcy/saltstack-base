chrony:
  pkg.installed:
    - name: chrony

chronyd:
  service.running:
    - enable: True
    - watch:
      - file: /etc/chrony.conf

  file.managed:
    - name: /etc/chrony.conf
    - source: salt://chrony/files/chrony.conf.client
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: chrony

