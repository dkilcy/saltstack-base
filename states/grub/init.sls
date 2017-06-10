
#/etc/default/grub:
#  file.replace:
#    - pattern: 'GRUB_CMDLINE_LINUX.*'
#    - repl: 'GRUB_CMDLINE_LINUX="elevator=deadline transparent_hugepage=never numa=off crashkernel=auto rhgb quiet"'

#grub2-mkconfig:
#  cmd.run:
#    - name: 'grub2-mkconfig -o /boot/grub2/grub.cfg'

