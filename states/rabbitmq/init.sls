rabbitmq-server:

  pkg.installed:
    - name: rabbitmq-server

  service.running:
    - name: rabbitmq-server
    - enable: True
    - reload: True
    - require:
      - pkg: rabbitmq-server
