#!/bin/bash

#My website http://press.__DOMAIN__.com is down. I think the database is messed up. HELP!

#This is because the inodes are 100% full and MySQL has crashed.

version=$(grep -o "release [6-7]" /etc/redhat-release|cut -d' ' -f2)

case $version in
    '6')
;;
    '7')
;;
esac
