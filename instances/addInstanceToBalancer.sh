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

for balancer in $loadBalancer;do
  echo "aws elbv2 register-targets --target-group-arn $balancer --targets Id=$instanceID --region $region"
  aws elbv2 register-targets --target-group-arn $balancer --targets Id=$instanceID --region $region
done

#for balancer in $loadBalancer;do
#  echo "aws elb register-instances-with-load-balancer --load-balancer-name $balancer --instances $instanceID --region $region" debug $balancer
#  aws elb register-instances-with-load-balancer --load-balancer-name $balancer --instances $instanceID --region $region
#done
