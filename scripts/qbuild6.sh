#!/bin/bash

#Quick build for a 1GB CentOS PVHM image with it the appropriate brown bag cloud-init script.
#Script new also be ran remotely via the following command:
# bash <(curl -sk https://necrux.com/qbuild6.sh)

cred_prompt () {
read -p "SSH User: " SSH_USER
read -p "SSH Port: " PORT
if [ -f ~/.ssh/id_rsa.pub ]; then
    read -p "SSH public key detected (~/.ssh/id_rsa.pub). Would you like to use that key? [Y/n] " ANS
    if [ "$ANS" == "y" ] || [ "$ANS" == "Y" ]; then
        KEY=$(cat ~/.ssh/id_rsa.pub)
    fi
else
    read -p "SSH Public Key: " KEY
fi
read -p "Mailgun Domain: " DOMAIN
read -p "Mailgun Password: " PASSWORD
read -p "Supnernova Environment Name: " ENV_NAME
}

cred_save () {
cat > ~/.qbuild << EOF
SSH_USER='$SSH_USER'
PORT='$PORT'
KEY='$KEY'
DOMAIN='$DOMAIN'
PASSWORD='$PASSWORD'
ENV_NAME='$ENV_NAME'
EOF
}


if [ -f ~/.qbuild ]; then
    read -p "Credential file detected (~/.qbuild). Would you like to use that file or regenerate? [Y/n] " ANS
    if [ "$ANS" == "y" ] || [ "$ANS" == "Y" ]; then
        source ~/.qbuild
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
sed -i "s%@PASSWORD@%$PASSWORD%g" /tmp/rhel6_troubleshooting

supernova $ENV_NAME boot --config-drive=true --flavor performance1-1 --image 8aac6fb5-4bd3-4256-bf6e-ff8500bf60cd --user-data /tmp/rhel6_troubleshooting Brown-Bag
