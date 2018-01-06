#!/bin/bash

source /home/ubuntu/aws-hostcontainer/instances/instanceVars.sh

host=$(hostname -s)

echo $host | grep -qie "\w01$"
status=$?
if [ "$status" -eq 0 ]
then
  loadBalancer="$geoserverLoadBalancerWrite"
else
  loadBalancer="$geoserverLoadBalancer"
fi

for balancer in $loadBalancer
do
  echo "aws elbv2 deregister-targets --target-group-arn $balancer --targets Id=$instanceID --region $region"
  aws elbv2 deregister-targets --target-group-arn ${balancer} --targets Id=${instanceID} --region ${region}
done
