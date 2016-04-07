#!/bin/bash

source /home/ubuntu/theeye_scripts/instances/instanceVars.sh

host=$(hostname -s)

for balancer in $loadBalancer;do
  echo "aws elb register-instances-with-load-balancer --load-balancer-name $balancer --instances $instanceID --region $region" debug $balancer
  aws elb register-instances-with-load-balancer --load-balancer-name $balancer --instances $instanceID --region $region
done
