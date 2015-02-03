#!/bin/bash

#Problem:
#My website http://press.__DOMAIN__.com is down. I think the database is messed up. HELP!

#Solution:
#This is because the inodes are 100% full and MySQL has crashed.

version=$(grep -o "release [6-7]" /etc/redhat-release|cut -d' ' -f2)

bash /root/brown-bag/scripts/restore_environment.sh

mkdir /root/junk/

case $version in
    '6')
/etc/init.d/mysqld stop

inodes=$(df -i|awk '/xvda1/ {print $4}')
;;
    '7')
systemctl stop mariadb.service

inodes=$(df -i|awk '/xvda1/ {print $4}')
;;
esac

for i in $(seq 1 $inodes)
    do touch /root/junk/$i
done
