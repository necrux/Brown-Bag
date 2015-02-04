#!/bin/bash

#Problem:
#I run a website with GoDaddy at http://__DOMAIN__ but I am looking to migrate to Rackspace. I have set up a subdomain at http://rackspace.__DOMAIN__ to test before changing DNS but MySQL is not working correctly. I have ensured that mysql-server is installed and I have also imported all of the data into the ‘rackspace’ database. Please see if you can determine the problem. Thanks.

#Solution:
#This is because the database user specified in /var/www/vhosts/rackspace.__DOMAIN__/configuration.php does not exist.

version=$(grep -o "release [6-7]" /etc/redhat-release|cut -d' ' -f2)

bash /root/brown-bag/scripts/restore_environment.sh

#case $version in
#    '6')
#;;
#    '7')
#;;
#esac

mysql -e "drop user 'rackspace_user'@'localhost';"
