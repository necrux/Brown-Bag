#!/bin/bash

#Quick build for a 1GB CentOS 6 PVHM image with it the appropriate brown bag cloud-init script.
#Script new also be ran remotely via the following command:
# bash <(curl -sk https://necrux.com/qbuild6.sh)
clear
echo -e '        ~~~~BROWN BAG FOR RHEL 6 DEPLOYMENT~~~~\n'

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

curl -sk https://raw.githubusercontent.com/necrux/cloud-init/master/rhel6_troubleshooting -o /tmp/rhel6_troubleshooting 
sed -i "s%@USER@%$SSH_USER%g" /tmp/rhel6_troubleshooting
sed -i "s%@SSH-PORT@%$PORT%g" /tmp/rhel6_troubleshooting
sed -i "s%@PUB-KEY@%$KEY%g" /tmp/rhel6_troubleshooting
sed -i "s%@@DOMAIN@%$DOMAIN%g" /tmp/rhel6_troubleshooting
sed -i "s%@MAIL-PASSWD@%$MAIL_PASSWD%g" /tmp/rhel6_troubleshooting

supernova $ENV_NAME boot --config-drive=true --flavor performance1-1 --image 8aac6fb5-4bd3-4256-bf6e-ff8500bf60cd --user-data /tmp/rhel6_troubleshooting Brown-Bag
