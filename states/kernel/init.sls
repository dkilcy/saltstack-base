

{% for k,v in salt['pillar.get']('kernel:sysctl').items() %}
{{ k }}:
sysctl.present:
- value: {{ v }}
{% endfor %}

