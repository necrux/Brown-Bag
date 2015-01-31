#!/bin/bash

#NOTE: This script assumes a .com TLD. If you are using a different TLD then you need to amend this file accordingly.
# sed -i 's/\.com/.<MY_TLD>/g' ./initialize_environment.sh && sed -i 's/cloud\.<MY_TLD>/cloud.com/g' ./initialize_environment.sh

clear

IP=$(ip address show eth0|awk -F'[t /]' '/inet / {print $7}')
version=$(grep -o "release [6-7]" /etc/redhat-release|cut -d' ' -f2)

echo "Please enter the primary apex/root domain for this project."
echo -e "   EXAMPLE: http://magento.\e[1;32mlecture\e[0m.com"
read -p "--> " APEX

sed -i "s/__DOMAIN__/$APEX/g" /root/Brown-Bag/scenario*.sh
sed -i "s/__DOMAIN__/$APEX/g" /etc/httpd/vhost.d/*.conf

ls /etc/httpd/vhost.d/*__DOMAIN__*|awk -v APEX=$APEX -F'__DOMAIN__' '{print "mv " $1 "__DOMAIN__" $2 " " $1 APEX $2}'|bash
ls -d /var/www/vhosts/*__DOMAIN__*|awk -v APEX=$APEX -F'__DOMAIN__' '{print "mv " $1 "__DOMAIN__" $2 " " $1 APEX $2}'|bash

read -p "Would you like to automatically add the DNS records to your Rackspace account \
(this option is only applicable if you are using Rackspace DNS)? [Y/n]: " ANS

if [ "$ANS" == "y" ] || [ "$ANS" == "Y" ]; then
    read -p "What is your Rackspace user name? " USERNAME
    read -p "What is your Rackspace DDI? " DDI
    read -p "What is your Rackspace API key? " API

    TOKEN=$(curl -s -X 'POST' -d "{\"auth\":{\"RAX-KSKEY:apiKeyCredentials\":{\"username\":\"$USERNAME\", \"apiKey\":\"$API\"}}}" \
-H "Content-Type: application/json" https://identity.api.rackspacecloud.com/v2.0/tokens|python -m json.tool|grep -A5 token|awk -F\" '/id/ {print $4}')

    ID=$(curl -s -H "X-Auth-Token: $TOKEN" https://dns.api.rackspacecloud.com/v1.0/$DDI/domains?name=$APEX.com \
|python -m json.tool|grep id|grep -o [0-9].*[0-9])

    curl -s -d '
{"records": [
{"name" : "wordpress.'"$APEX"'.com","type" : "A","data" : '\"$IP\"'},
{"name" : "magento.'"$APEX"'.com","type" : "A","data" : '\"$IP\"'},
{"name" : "rackspace.'"$APEX"'.com","type" : "A","data" : '\"$IP\"'}
]}' -H "X-Auth-Token: $TOKEN" -H "Content-Type: application/json" "https://dns.api.rackspacecloud.com/v1.0/$DDI/domains/$ID/records"

else
    echo -e "\nAll files updated. To complete the exercise create the following A records:\n"
    for i in $(ls /var/www/vhosts/); do echo "$IP -> $i"; done

    echo -e "\nAlternatively you can add the following entries to your host file:\n"
    for i in $(ls /var/www/vhosts/); do echo "$IP $i"; done
fi

cat << EOF

Be sure to visit the website in your browser to finish configuring the environments:

http://wordpress.$APEX.com

Database: wordpress
DB User: wordpress_user
DB Password: wordpress-lover

http://magento.$APEX.com

Database: magento
DB User: magento_user
DB Password: magento-lover

http://rackspace.$APEX.com

Database: rackspace
DB User: rackspace_user
DB Password: joomla-lover

EOF

case $version in
    '6')
/etc/init.d/httpd restart
;;
    '7')
systemctl restart httpd.service
;;
esac
