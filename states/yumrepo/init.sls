
#clean_yumrepo:
#  file.directory:
#    - name: /etc/yum.repos.d
#    - clean: True
#    - exclude_pat: "*local.repo*"

/etc/yum.repos.d/CentOS-Base.repo:
  ini.options_present:
    - sections: 
        base:
          enabled: 0
        updates:
          enabled: 0
        extras:
          enabled: 0

/etc/yum.repos.d/local.repo:
  file.managed:
    - name: /etc/yum.repos.d/local.repo
    - source: salt://yumrepo/files/local.repo
    - replace: True

yum_clean_all:
  cmd.run:
    - name: 'yum clean all'
    - require:
      - file: /etc/yum.repos.d/local.repo
