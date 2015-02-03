#!/bin/bash

clear

IP=$(ip address show eth0|awk -F'[t /]' '/inet / {print $7}')
version=$(grep -o "release [6-7]" /etc/redhat-release|cut -d' ' -f2)

echo "Please enter the primary domain for this project (all project sites will be created as subdomains of this site):"
echo -e "   EXAMPLE: http://magento.\e[1;32mlecture.com\e[0m"
read -p "--> " DOMAIN

echo "127.0.0.1 magento.$DOMAIN" >> /etc/hosts

sed -i "s/__DOMAIN__/$DOMAIN/g" /root/brown-bag/scenario*.sh
sed -i "s/__DOMAIN__/$DOMAIN/g" /etc/httpd/vhost.d/*.conf

ls /etc/httpd/vhost.d/*__DOMAIN__*|awk -v DOMAIN=$DOMAIN -F'__DOMAIN__' '{print "mv " $1 "__DOMAIN__" $2 " " $1 DOMAIN $2}'|bash
ls -d /var/www/vhosts/*__DOMAIN__*|awk -v DOMAIN=$DOMAIN -F'__DOMAIN__' '{print "mv " $1 "__DOMAIN__" $2 " " $1 DOMAIN $2}'|bash

echo -e "\nWould you like to automatically add the DNS records to your Rackspace account?"
echo "    NOTE: This option is only applicable if you are using Rackspace DNS."
read -p "[Y/n]: " ANS

if [ "$ANS" == "y" ] || [ "$ANS" == "Y" ]; then
    read -p "What is your Rackspace user name? " USERNAME
    read -p "What is your Rackspace DDI? " DDI
    read -p "What is your Rackspace API key? " API

    TOKEN=$(curl -s -X 'POST' -d "{\"auth\":{\"RAX-KSKEY:apiKeyCredentials\":{\"username\":\"$USERNAME\", \"apiKey\":\"$API\"}}}" \
-H "Content-Type: application/json" https://identity.api.rackspacecloud.com/v2.0/tokens|python -m json.tool|grep -A5 token|awk -F\" '/id/ {print $4}')

    ID=$(curl -s -H "X-Auth-Token: $TOKEN" https://dns.api.rackspacecloud.com/v1.0/$DDI/domains?name=$DOMAIN \
|python -m json.tool|grep id|grep -o [0-9].*[0-9])

    curl -s -d '
{"records": [
{"name" : "wordpress.'"$DOMAIN"'","type" : "A","data" : '\"$IP\"'},
{"name" : "magento.'"$DOMAIN"'","type" : "A","data" : '\"$IP\"'},
{"name" : "rackspace.'"$DOMAIN"'","type" : "A","data" : '\"$IP\"'}
]}' -H "X-Auth-Token: $TOKEN" -H "Content-Type: application/json" "https://dns.api.rackspacecloud.com/v1.0/$DDI/domains/$ID/records" 2>&1 > /dev/null

else
    echo -e "\nAll files updated. To complete the exercise create the following A records:\n"
    for i in $(ls /var/www/vhosts/); do echo "$IP -> $i"; done

    echo -e "\nAlternatively you can add the following entries to your host file:\n"
    for i in $(ls /var/www/vhosts/); do echo "$IP $i"; done
fi

tee /root/CMS_info.txt << EOF

Be sure to visit the website in your browser to finish configuring the environments:

http://wordpress.$DOMAIN

Database: wordpress
DB User: wordpress_user
DB Password: wordpress-lover

http://magento.$DOMAIN

Database: magento
DB User: magento_user
DB Password: magento-lover

http://rackspace.$DOMAIN

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
