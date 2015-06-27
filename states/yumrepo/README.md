
### yumrepo

For configuring minions to use the local yum repository on the Salt master (aliased as `yumrepo`).  

Contents: 
- init.sls: 
- files:
  - `local.repo`: Points the base,updates,extras and epel repos to the local mirror aliased as `yumrepo`

### Notes

- Install the EPEL on CentOS (requires CentOS-Extra repo): `yum install epel-release`
- List all installed packages: `rpm -qa`  
- Show contents of an rpm:  `rpm -q -filesbypkg -p gnome-applet-sensors-2.2.7-1.el6.rf.x86_64.rpm` 
- Show contents of a package:  `repoquery --list openstack-selinux`
- Download an rpm and all its dependencies: `repotrack salt-master`
- List available repositories: `yum repolist`
- Clean yum cache: `yum clean all`
- Info about package: `yum info git`

### 
