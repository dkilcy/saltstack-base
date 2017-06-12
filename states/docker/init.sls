
docker-engine:
  pkg.installed:
    - version: 1.13.1-1.el7
#    - version: 1.10.3-1.el7

docker_service:
  service.running:
    - name: docker
    - enable: True

