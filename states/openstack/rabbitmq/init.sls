
rabbitmq_user.present:
  - name: {{ salt['pillar.get']('openstack:rabbitmq:user') }}
  - password: {{ salt['pillar.get']('openstack:rabbitmq:pass') }}
  - force: True
  - tags:
    - monitoring
    - user
  - perms:
    - '/':
      - '.*'
      - '.*'
      - '.*'
#  - runas: rabbitmq

