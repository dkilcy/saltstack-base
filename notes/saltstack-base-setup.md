
### Setup Git and saltstack-base repository


1. Install git as **root** user: `yum install git`
2. Configure GitHub and pull projects as **devops** user

 ```bash
git config --global user.name "dkilcy"
git config --global user.email "david@kilcyconsulting.com"
```

3. Clone the repository

 ```bash
mkdir ~/git 
cd ~/git
git clone https://github.com/dkilcy/saltstack-base.git
```

4. Create a YAML file to hold the customized Salt configuration.  As **root** user, execute `vi /etc/salt/master.d/99-salt-envs.conf` and add the following to the new file:

 ```yaml
file_roots:
  base:
    - /srv/salt/base/states
pillar_roots:
  base:
    - /srv/salt/base/pillar
```

5. Point Salt to the development environment as **root** user.

 ```bash
mkdir -p /srv/salt
ln -sf /home/devops/git/saltstack-base /srv/salt/base
```

6. Copy the hosts file from /home/devops/git/saltstack-base/network/files/hosts to /etc/hosts
```
cp /home/devops/git/saltstack-base/network/files/hosts /etc/
```
