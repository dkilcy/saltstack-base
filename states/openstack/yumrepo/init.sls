openstack-repo:
  pkgrepo.managed:
    - name: local-centos-openstack-ocata
    - humanname: local-centos-openstack-ocata
    - baseurl: {{ salt['pillar.get']('openstack:repo:baseurl') }}
    - gpgcheck: 0
    - enabled: True
  cmd.run:
    - name: yum -y clean all
