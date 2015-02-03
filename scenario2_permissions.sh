#!/bin/bash

#Problem:
#My WordPress site http://word.__DOMAIN__.com is loading a blank page. I can access the backend, http://word.__DOMAIN__.com/wp-login.php, but the main site no longer works. My developer Dave has recently made some changes to the site.

#Solution:
#This is due to improper permissions on /var/www/vhosts/word.__DOMAIN__.com/index.php

version=$(grep -o "release [6-7]" /etc/redhat-release|cut -d' ' -f2)

bash /root/brown-bag/scripts/restore_environment.sh

chown dave:dave /var/www/vhosts/wordpress.*.com/index.php
chmod 640 /var/www/vhosts/wordpress.*.com/index.php

case $version in
    '6')
/etc/init.d/httpd restart
;;
    '7')
systemctl restart httpd.service
;;
esac
