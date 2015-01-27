#!/bin/bash

#My web site http://press.__DOMAIN__.com loads intermittently, if at all. Please investigate.

#This is because the database user is receiving an exesive amount of traffic from a single IP. Be sure to run the /root/brown-bag/scripts/dos.sh script from a different server.

version=$(grep -o "release [6-7]" /etc/redhat-release|cut -d' ' -f2)

case $version in
    '6')
;;
    '7')
;;
esac
