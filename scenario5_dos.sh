#!/bin/bash

#Problem:
#My web site http://press.__DOMAIN__.com loads intermittently, if at all. Please investigate.

#Solution:
#This is because the database user is receiving an exesive amount of traffic from a single IP. Be sure to run the /root/brown-bag/scripts/dos.sh script from a different server.

version=$(grep -o "release [6-7]" /etc/redhat-release|cut -d' ' -f2)

rm -rf /root/junk/

case $version in
    '6')
/etc/init.d/httpd restart
/etc/init.d/mysqld restart

iptables -I INPUT -m conntrack --ctstate NEW -m tcp -p tcp --dport 80 -j ACCEPT
/etc/init.d/iptables save
;;
    '7')
systemctl restart httpd.service
systemctl restart mariadb.service

firewall-cmd --zone=public --add-service=http
firewall-cmd --zone=public --add-service=http --permanent
;;
esac
