#!/bin/bash

## exit

echo "This is going to destroy the OpenStack cluster"
echo "You have 10 seconds to abort...." 
sleep 10
echo "Starting..."

salt 'c*' cmd.run 'yum -y erase \*openstack\* ; yum -y erase libvirtd' 
salt 'c*' cmd.run 'rm -Rf /etc/nova ; rm -Rf /etc/neutron ; rm -Rf /etc/keystone ; rm -Rf /etc/glance ; rm -Rf /var/log/keystone ; rm -Rf /var/log/glance ; rm -Rf /var/log/nova ; rm -Rf /var/log/neutron'

salt 'controller' cmd.run 'yum -y erase mod_wsgi httpd ; rm -Rf /etc/httpd ; rm -Rf /var/log/httpd'
salt 'controller' cmd.run 'yum -y erase memcached rabbitmq-server'
salt 'controller' cmd.run 'yum -y erase \*mariadb\* ; rm -Rf /var/lib/mysql ; rm -Rf /etc/my.cnf.db'

echo "End of program."
