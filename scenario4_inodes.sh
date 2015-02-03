#!/bin/bash

#Problem:
#My website http://press.__DOMAIN__.com is down. I think the database is messed up. HELP!

#Solution:
#This is because the inodes are 100% full and MySQL has crashed.

version=$(grep -o "release [6-7]" /etc/redhat-release|cut -d' ' -f2)

rm -rf /root/junk/
mkdir /root/junk/

case $version in
    '6')
/etc/init.d/httpd restart
/etc/init.d/mysqld stop

iptables -I INPUT -m conntrack --ctstate NEW -m tcp -p tcp --dport 80 -j ACCEPT
/etc/init.d/iptables save

inodes=$(df -i|awk '/xvda1/ {print $4}')
;;
    '7')
systemctl restart httpd.service
systemctl stop mariadb.service

firewall-cmd --zone=public --add-service=http
firewall-cmd --zone=public --add-service=http --permanent

inodes=$(df -i|awk '/xvda1/ {print $4}')
;;
esac

for i in $(seq 1 $inodes)
    do touch /root/junk/$i
done
