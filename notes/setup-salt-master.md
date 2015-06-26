

### Setup Salt Master

1. Install git as **root** user: `yum install git`
2. Configure GitHub and pull projects as **devops** user

 ```bash
git config --global user.name "dkilcy"
git config --global user.email "david@kilcyconsulting.com"
 
mkdir ~/git ; cd ~/git
git clone https://github.com/dkilcy/saltstack-base.git
```

3. Copy the hosts file from /home/devops/git/saltstack-base/network/files/hosts to /etc/hosts
```
cp /home/devops/git/saltstack-base/network/files/hosts /etc/
```

3. Install the Salt master and minion on the workstation as **root** user

 ```bash
yum install salt-master salt-minion
salt --version
mkdir /etc/salt/master.d
```

3. Create a YAML file to hold the customized Salt configuration.  As **root** user, execute `vi /etc/salt/master.d/99-salt-envs.conf` and add the following to the new file:

```yaml
file_roots:
  base:
    - /srv/salt/base/states
pillar_roots:
  base:
    - /srv/salt/base/pillar
```

4. Point Salt to the development environment as **root** user.

 ```bash
mkdir /srv/salt
ln -sf /home/devops/git/saltstack-base /srv/salt/base
```

5. Start the Salt master on the workstation machine as **root** user.

 ```bash 
systemctl start salt-master.service
systemctl enable salt-master.service
```
