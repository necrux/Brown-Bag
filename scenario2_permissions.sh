#!/bin/bash

#Problem:
#My WordPress site http://word.__DOMAIN__ is loading a blank page. I can access the backend, http://word.__DOMAIN__/wp-login.php, but the main site no longer works. My developer Dave has recently made some changes to the site.

#Solution:
#This is due to improper permissions on /var/www/vhosts/word.__DOMAIN__/index.php

#Instructor Notes:
#It looks like Dave may have uploaded a new version of /var/www/vhosts/word.__DOMAIN__/index.php (note the ownership), and it has improper permissions.

version=$(grep -o "release [6-7]" /etc/redhat-release|cut -d' ' -f2)

bash /root/brown-bag/scripts/restore_environment.sh

chown dave:dave /var/www/vhosts/wordpress.*/index.php
chmod 640 /var/www/vhosts/wordpress.*/index.php

case $version in
    '6')
/etc/init.d/httpd restart
;;
    '7')
systemctl restart httpd.service
;;
esac
