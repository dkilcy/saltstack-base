
clean_yumrepo:
  file.directory:
    - name: /etc/yum.repos.d
    - clean: True
    - exclude_pat: "*local.repo*"

/etc/yum.repos.d/local.repo:
  file.managed:
    - name: /etc/yum.repos.d/local.repo
    - source: salt://yumrepo/files/local.repo
    - replace: False
