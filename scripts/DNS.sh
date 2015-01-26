#!/bin/bash
clear

IP=$(ip address show eth0|awk -F'[t /]' '/inet / {print $7}')

echo "Please enter the root/apex domain for this project."
echo -e "   EXAMPLE: http://magento.\e[1;32mlecture\e[0m.com"
read -p "--> " APEX

sed -i "s/__DOMAIN__/$APEX/g" /root/Brown-Bag/scenario*.sh
sed -i "s/__DOMAIN__/$APEX/g" /etc/httpd/vhost.d/*.conf

ls /etc/httpd/vhost.d/*__DOMAIN__*|awk -v APEX=$APEX -F'__DOMAIN__' '{print "mv " $1 "__DOMAIN__" $2 " " $1 APEX $2}'|bash
ls -d /var/www/vhosts/*__DOMAIN__*|awk -v APEX=$APEX -F'__DOMAIN__' '{print "mv " $1 "__DOMAIN__" $2 " " $1 APEX $2}'|bash

echo -e "\nAll files updated. To complete the exercise create the following A records:\n"
for i in $(ls /var/www/vhosts/); do echo "$IP -> $i"; done

echo -e "\nAlternatively you can add the following entries to your host file:\n"
for i in $(ls /var/www/vhosts/); do echo "$IP $i"; done
echo

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

/etc/init.d/httpd restart
