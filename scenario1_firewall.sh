#!/bin/bash

#Problem:
#My Magento store at http://mage.__DOMAIN__.com did not come back online after the recent host reboots. Please treat this as a matter of urgency as this outage is costing me sales.

#Solution:
#This is due to a firewall rule opening up port 80 being run but not saved.

version=$(grep -o "release [6-7]" /etc/redhat-release|cut -d' ' -f2)
SSH=$(netstat -pt|awk '/ssh/ {print $4}'|cut -d: -f2)

bash /root/brown-bag/scripts/restore_environment.sh

case $version in
    '6')
/etc/init.d/httpd restart
/etc/init.d/mysqld restart

cat > /etc/sysconfig/iptables << EOF
*filter
:INPUT ACCEPT [0:0]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
-A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
-A INPUT -p icmp -j ACCEPT
-A INPUT -i lo -j ACCEPT
-A INPUT -m conntrack --ctstate NEW -m tcp -p tcp --dport $SSH -j ACCEPT
-A INPUT -j REJECT --reject-with icmp-host-prohibited
-A FORWARD -j REJECT --reject-with icmp-host-prohibited
COMMIT
EOF
/etc/init.d/iptables restart
echo "iptables -I INPUT -m conntrack --ctstate NEW -m tcp -p tcp --dport 80 -j ACCEPT" >> /root/.bash_history
;;
    '7')
systemctl restart httpd.service
systemctl restart mariadb.service

firewall-cmd --zone=public --remove-service=http
firewall-cmd --zone=public --remove-service=http --permanent
firewall-cmd --zone=public --remove-port=80/tcp
firewall-cmd --zone=public --remove-port=80/tcp --permanent
echo "firewall-cmd --zone=public --add-service=http" >> /root/.bash_history
;;
esac

shutdown -r now
