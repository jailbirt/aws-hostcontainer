#!/bin/bash

source /home/ubuntu/aws-hostcontainer/instances/instanceVars.sh

host=$(hostname -s)

#Instance tagging
echo "Taggging Instance: $instanceID with Tag: $host"
ec2addtag $instanceID --tag Name=$host --region $region

#Volume tagging
tag="main_$host"
for i in $(ec2-describe-volumes | grep $instanceID | grep -v 'sdh' | awk '{print $2}')
do
  ec2-create-tags $i -t Name=$tag
done
