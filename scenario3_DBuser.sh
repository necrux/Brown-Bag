#!/bin/bash

#I run a website with GoDaddy at http://__DOMAIN__.com but I am looking to migrate to Rackspace. I have set up a subdomain at http://rackspace.__DOMAIN__.com to test before changing DNS but MySQL is not working correctly. I have ensured that mysql-server is installed and I have also imported all of the data into the ‘rackspace’ database. Please see if you can determine the problem. Thanks.

#This is because the database user specified in /var/www/vhosts/rackspace.__DOMAIN__.com/configuration.php does not exist.

version=$(grep -o "release [6-7]" /etc/redhat-release|cut -d' ' -f2)

rm -rf /root/junk/

case $version in
    '6')
/etc/init.d/httpd restart
/etc/init.d/mysqld restart

iptables -I INPUT -m conntrack --ctstate NEW -m tcp -p tcp --dport 80 -j ACCEPT
/etc/init.d/iptables save
;;
    '7')
systemctl restart httpd.service
systemctl restart mariadb.service

firewall-cmd --zone=public --add-service=http
firewall-cmd --zone=public --add-service=http --permanent
;;
esac

mysql -e "drop user 'rackspace_user'@'localhost';"
