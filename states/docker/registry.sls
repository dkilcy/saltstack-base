#
#
#

{% set volume = salt['pillar.get']('docker-registry:volume') %}
{% set port = salt['pillar.get']('docker-registry:port') %}

#
# Create docker volumes
#
{{ volume }}:
  file.directory:
    - makedirs: True
{{ volume }}/data:
  file.directory
{{ volume }}/auth:
  file.directory

# Create user and password for registry
#
docker-registry-users:
  cmd.run:
    - name: htpasswd -Bbn {{ salt['pillar.get']('docker-registry:username') }} {{ salt['pillar.get']('docker-registry:password') }} > {{ volume }}/auth/htpasswd

#
# Pull the docker container if not present
#
{{ salt['pillar.get']('docker-registry:image') }}:
  dockerng.image_present

#
# Run the registry container
#
docker-registry-container:
  dockerng.running:
    - name: local-registry
    - image: '{{ salt['pillar.get']('docker-registry:image') }}'
    - detach: True
    - port_bindings: {{ port }}:{{ port }}/tcp
    - binds:
      - /etc/pki/scality:/certs:ro
      - {{ volume }}/data:/var/lib/registry:rw
      - {{ volume }}/auth:/auth:rw
    - environment:
      - REGISTRY_AUTH: htpasswd
      - REGISTRY_AUTH_HTPASSWD_REALM: "Registry Realm"
      - REGISTRY_AUTH_HTPASSWD_PATH: /auth/htpasswd
      - REGISTRY_HTTP_TLS_CERTIFICATE: /certs/registry.crt
      - REGISTRY_HTTP_TLS_KEY: /certs/registry.key
    - restart_policy: always

