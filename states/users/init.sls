
{% set user_list = salt['pillar.get']('user_list') %}

/root/.bashrc:
  file.append:
    - text: 
      - export PS1="\e[1;31m[\u@\h \W]$ \e[m"

/root/.vimrc:
  file.managed:
    - name: /root/.vimrc
    - source: salt://vim/.vimrc
    - mode: 644
    - user: root
    - group: root
    - require:
      - pkg: {{ pillar['pkgs']['vim'] }}

{% for user in user_list %}

{{ user.name }}:
  user.present:
    - name: {{ user.name }}
    - shell: {{ user.shell }}

  file.managed:
    - name: /etc/sudoers.d/{{ user.name }}
    - contents: |
        {{ user.name }} ALL=(ALL)  NOPASSWD: ALL

{{ user.name }}_authorized_keys:
  file.managed:
    - name: /home/{{ user.name }}/.ssh/authorized_keys
    - contents: {{ user.ssh_public_key }}
    - makedirs: True
    - dir_mode: 700
    - mode: 600
    - user: {{ user.name }}
    - group: {{ user.group }}

{{ user.name }}_vimrc:
  file.managed:
    - name: /home/{{ user.name }}/.vimrc
    - source: salt://vim/.vimrc
    - mode: 644
    - user: {{ user.name }}
    - group: {{ user.group }}
    - require: 
      - pkg: {{ pillar['pkgs']['vim'] }} 

/home/{{ user.name }}/.bashrc:
  file.append:
    - text:
      - export PS1="\e[1;36m[\u@\h \W]$ \e[m"

{% endfor %}
