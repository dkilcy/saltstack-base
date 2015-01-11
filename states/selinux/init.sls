
#policycoreutils:
#  pkg.installed:
#    - pkgs:
#      - policycoreutils
#      - policycoreutils-python

iptables:
  service.dead:
    - name: iptables
    - enable: False


