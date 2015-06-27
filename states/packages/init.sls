
recommended_packages:
  pkg.installed:
    - pkgs:
{% for pkg in salt['pillar.get']('packages:recommended') %}
      - {{ pkg }}
{% endfor %}


