
### Setup Git and saltstack-base repository


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
