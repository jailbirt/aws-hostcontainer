#!/bin/bash
scriptsPath='/home/ubuntu/aws-hostcontainer'
aws='/usr/bin/aws'
source $scriptsPath/instances/instanceVars.sh --printvars
echo Get Your Configurations $aws s3 sync s3://$configurationsBucket /home/ubuntu/configs
$aws s3 sync s3://$configurationsBucket /home/ubuntu/configs
sudo chown -R ubuntu.ubuntu /home/ubuntu/configs
