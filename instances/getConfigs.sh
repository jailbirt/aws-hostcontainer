#!/bin/bash
scriptsPath='/home/ubuntu/aws-hostcontainer'
aws=$(which aws)
source $scriptsPath/instances/instanceVars.sh --printvars
echo Get Your Configurations $aws s3 sync s3://$configurationsBucket /home/ubuntu/configs
sudo $aws s3 sync s3://$configurationsBucket /home/ubuntu/configs --region $region
sudo chown -R ubuntu.ubuntu /home/ubuntu/configs
find /home/ubuntu/configs -type f -iname "*.sh" -exec chmod a+x {} +
