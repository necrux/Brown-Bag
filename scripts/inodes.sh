#!/bin/bash

read -p "This script can take hours to run. It is recommended that you run it from a screen session. Do you wish to continue? [Y/n]: " ANS

if [ "$ANS" == "y" ] || [ "$ANS" == "Y" ]; then
    inodes=$(df -i|awk '/xvda1/ {print $4-1000}')  #Leave 1000 inodes free.

    mkdir /root/backup/

    for i in $(seq 1 $inodes)
        do touch /root/backup/$i
    done
else
    exit
fi
