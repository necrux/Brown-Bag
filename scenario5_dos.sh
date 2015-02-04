#!/bin/bash

#Problem:
#My web site http://press.__DOMAIN__ loads intermittently, if at all. Please investigate.

#Solution:
#This is because the database user is receiving an exesive amount of traffic from a single IP. Be sure to run the /root/brown-bag/scripts/dos.sh script from a different server.
#Compare page loads time before and after dropping the IP: time curl -I wordpress.__DOMAIN__
#

version=$(grep -o "release [6-7]" /etc/redhat-release|cut -d' ' -f2)

bash /root/brown-bag/scripts/restore_environment.sh

#case $version in
#    '6')
#;;
#    '7')
#;;
#esac
