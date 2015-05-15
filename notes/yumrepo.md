
### yumrepo

For configuring minions to use the local yum repository on the Salt master (aliased as `yumrepo`).
**This is not to be run on the Salt master.**

Contents: 
- init.sls: 
  - Cleans out the contents of /etc/yum.repos.d excluding `*local.repo*`
  - Copies the `local.repo` file to /etc/yum.repos.d
- files:
  - `local.repo`: Points the base,updates,extras and epel repos to the local mirror aliases as `yumrepo`

### Notes

- Install the EPEL on CentOS (requires CentOS-Extra repo): `yum install epel-release`
- List all installed packages: `rpm -qa`  
- Show contents of an rpm:  `rpm -q -filesbypkg -p gnome-applet-sensors-2.2.7-1.el6.rf.x86_64.rpm` 
- Show contents of a package:  `repoquery --list openstack-selinux`
- Download an rpm and all its dependencies: `repotrack salt-master`
