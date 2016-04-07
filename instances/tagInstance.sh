#!/bin/bash

source /home/ubuntu/aws-hostcontainer/instances/instanceVars.sh

host=$(hostname -s)

echo "Tag instance: $instanceID con tag: $host"
ec2addtag $instanceID --tag Name=$host --region $region

#tag de volumenes.
tag="main_$host"
for i in $(ec2-describe-volumes | grep $instanceID | grep -v 'sdh' | awk '{print $2}')
do
  ec2-create-tags $i -t Name=$tag
done
