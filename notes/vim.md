
### vim

Installs either vim or vim-enhanced based on os_family grain (Debian or RedHat).  
See also [pkg](https://github.com/dkilcy/saltstack-base/tree/master/pillar/pkg) pillar

Contents:

- init.sls
  -  Installs vim
- files:
  - `.vimrc`: sets expandtab and tabstop=4 to python formatting.  Referenced by [users](https://github.com/dkilcy/saltstack-base/tree/master/states/users) state.
  
