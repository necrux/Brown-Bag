#!/bin/bash

#My Magento store at http://mage.__DOMAIN__.com did not come back online after the recent host reboots. Please treat this as a matter of urgency as this outage is costing me sales.

#This is due to a firewall rule opening up port 80 being run but not saved.

version=$(grep -o "release [6-7]" /etc/redhat-release|cut -d' ' -f2)

case $version in
    '6')
;;
    '7')
;;
esac
