#!/bin/bash

#Quick build for a 1GB CentOS 7 PVHM image with it the appropriate brown bag cloud-init script.
#Script new also be ran remotely via the following command:
clear
echo -e '        ~~~~BROWN BAG FOR RHEL 7 DEPLOYMENT~~~~\n'

cred_prompt () {
read -p "SSH User: " SSH_USER
read -p "SSH Port [22]: " PORT
if [ "$PORT" == "" ]; then
    PORT=22
else
    until [ "$PORT" -ge 1 -a "$PORT" -le "65535" ] 2> /dev/null; do
        echo "$PORT is not a valid entry. Please try again."
        read -p "SSH Port [22]: " PORT
    done
fi
if [ -f ~/.ssh/id_?sa.pub ]; then
    read -p "SSH public key detected. Would you like to use that key? [Y/n] " ANS
    if [ "$ANS" == "y" ] || [ "$ANS" == "Y" ]; then
        KEY=$(cat ~/.ssh/id_?sa.pub)
    else
        read -p "SSH Public Key: " KEY
        while [ "$KEY" == "" ]; do
            echo "SSH key required for login. Please enter a valid key."
            read -p "SSH Public Key: " KEY
        done
    fi
else
    read -p "No SSH public key detected. Would you like to generate one? [Y/n] " ANS
    if [ "$ANS" == "y" ] || [ "$ANS" == "Y" ]; then
        ssh-keygen -q -t rsa -f ~/.ssh/id_rsa -N ""
        KEY=$(cat ~/.ssh/id_rsa.pub)
    else
        read -p "SSH Public Key: " KEY
        while [ "$KEY" == "" ]; do
            echo "SSH key required for login. Please enter a valid key."
            read -p "SSH Public Key: " KEY
        done
    fi
fi
read -p "Mailgun Domain: " DOMAIN
read -p "Mailgun Password: " MAIL_PASSWD
read -p "Supnernova Environment Name: " ENV_NAME
}

cred_save () {
cat > ~/.qbuild << EOF
SSH_USER='$SSH_USER'
PORT='$PORT'
KEY='$KEY'
DOMAIN='$DOMAIN'
MAIL_PASSWD='$MAIL_PASSWD'
ENV_NAME='$ENV_NAME'
EOF
}

if [ -f ~/.qbuild ]; then
    read -p "Credential file detected (~/.qbuild). Would you like to use that file? [Y/n] " ANS
    if [ "$ANS" == "y" ] || [ "$ANS" == "Y" ]; then
        source ~/.qbuild
    else
        cred_prompt
        read -p "Would you like to save this information to ~/.qbuild for even speedier future builds? [Y/n] " ANS
        if [ "$ANS" == "y" ] || [ "$ANS" == "Y" ]; then
            cred_save
        fi
    fi
else
    cred_prompt
    read -p "Would you like to save this information to ~/.qbuild for even speedier future builds? [Y/n] " ANS
    if [ "$ANS" == "y" ] || [ "$ANS" == "Y" ]; then
        cred_save
    fi
fi

curl -sk https://raw.githubusercontent.com/necrux/cloud-init/master/rhel7_troubleshooting -o /tmp/rhel7_troubleshooting 
sed -i "s%@USER@%$SSH_USER%g" /tmp/rhel7_troubleshooting
sed -i "s%@SSH-PORT@%$PORT%g" /tmp/rhel7_troubleshooting
sed -i "s%@PUB-KEY@%$KEY%g" /tmp/rhel7_troubleshooting
sed -i "s%@@DOMAIN@%$DOMAIN%g" /tmp/rhel7_troubleshooting
sed -i "s%@MAIL-PASSWD@%$MAIL_PASSWD%g" /tmp/rhel7_troubleshooting

supernova $ENV_NAME boot --config-drive=true --flavor performance1-1 --image d6e18edc-d7dc-4639-b55f-56012798df33 --user-data /tmp/rhel7_troubleshooting Brown-Bag
