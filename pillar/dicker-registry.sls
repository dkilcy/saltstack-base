docker-registry:
  image: 'registry:2'
  username: local
  password: local
  volume: /var/lib/registry
  host: ws2.lab.local
  port: 5000
