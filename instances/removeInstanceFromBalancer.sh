#!/bin/bash

source /home/ubuntu/aws-hostcontainer/instances/instanceVars.sh

for balancer in $loadBalancer
do
  echo "Removing Instance: $instanceID from Balancer: $balancer"
  aws elb deregister-instances-from-load-balancer --load-balancer-name $balancer --instances $instancesID
done
