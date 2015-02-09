#!/bin/bash

#Problem:
#My website http://press.__DOMAIN__ is down. I think the database is messed up. HELP!

#Solution:
#This is because the inodes are 100% full and MySQL has crashed.
#Delete /root/junk/ to free up ~1000 inodes. Be sure to restart MySQL.

#Instructor Notes:
#The bulk of the inodes are in /root/backup/; parsing this file will take a very long time. Suggest Performing triage if able, notifying the customer ASAP, and starting a scan of the system.

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
