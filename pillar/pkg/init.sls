pkgs:
  {% if grains['os_family'] == 'RedHat' %}
  apache: httpd
  git: git
  python-dev: python-devel
  vim: vim-enhanced
  {% elif grains['os_family'] == 'Debian' %}
  apache: apache2
  git: git-core
  python-dev: python-dev
  vim: vim
  {% endif %}

