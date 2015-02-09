#!/bin/bash

#Problem:
#I run a website with GoDaddy at http://__DOMAIN__ but I am looking to migrate to Rackspace. I have set up a subdomain at http://rackspace.__DOMAIN__ to test before changing DNS but MySQL is not working correctly. I have ensured that mysql-server is installed and I have also imported all of the data into the ‘rackspace’ database. Please see if you can determine the problem. Thanks.

#Solution:
#This is because the database user specified in /var/www/vhosts/rackspace.__DOMAIN__/configuration.php does not exist.
#mysql -e "grant all on rackspace.* to 'rackspace_user'@'localhost' identified by 'joomla-lover';"

#Instructor Notes:
#Change to the DocumentRoot and see if anyone recognizes the CMS; if not ask how they would respond. Guide them to the README file and suggest they look for hints in the file structure. Running less on configuration.php and searching for mysql will do the trick.
#You can verify that no user has rights on this database by running:
#SELECT user,host FROM mysql.db WHERE db='rackspace';

version=$(grep -o "release [6-7]" /etc/redhat-release|cut -d' ' -f2)

bash /root/brown-bag/scripts/restore_environment.sh

#case $version in
#    '6')
#;;
#    '7')
#;;
#esac

mysql -e "drop user 'rackspace_user'@'localhost';"
