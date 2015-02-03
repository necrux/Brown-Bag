#!/bin/bash

#This script is to restore the environment back to a working status and should be included as the first item for each scenario scripted.
#If applicable each scenario added should have the solution scripted here. This will ensure a clean environment.

version=$(grep -o "release [6-7]" /etc/redhat-release|cut -d' ' -f2)
SSH=$(netstat -pt|awk '/ssh/ {print $4}'|cut -d: -f2)

rm -rf /root/junk/

chown apache:apache /var/www/vhosts/wordpress.*.com/index.php
chmod 644 /var/www/vhosts/wordpress.*.com/index.php

mysql -e "grant all on rackspace.* to 'rackspace_user'@'localhost' identified by 'joomla-lover';"

case $version in
    '6')
/etc/init.d/httpd restart
/etc/init.d/mysqld restart

cat > /etc/sysconfig/iptables << EOF
*filter
:INPUT ACCEPT [0:0]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
-A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
-A INPUT -p icmp -j ACCEPT
-A INPUT -i lo -j ACCEPT
-A INPUT -m conntrack --ctstate NEW -m tcp -p tcp --dport $SSH -j ACCEPT
-A INPUT -m conntrack --ctstate NEW -m tcp -p tcp --dport 80 -j ACCEPT
-A INPUT -j REJECT --reject-with icmp-host-prohibited
-A FORWARD -j REJECT --reject-with icmp-host-prohibited
COMMIT
EOF
/etc/init.d/iptables restart
;;
    '7')
systemctl restart httpd.service
systemctl restart mariadb.service

firewall-cmd --zone=public --add-service=http
firewall-cmd --zone=public --add-service=http --permanent
;;
esac
