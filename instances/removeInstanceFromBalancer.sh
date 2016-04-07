#!/bin/bash

source /home/ubuntu/aws-hostcontainer/instances/instanceVars.sh

host=$(hostname -s)

case $instanceType in

*awsnodep)

 loadBalancer=$prodNodeLoadBalancer ;;

*awsgeoserverp)

 loadBalancer=$prodGeoserverLoadBalancer ;;

*awsnodes)

  loadBalancer=$stagingNodeLoadBalancer ;;

*)

  echo "Unknown instanceType:$instanceType"
  exit
  ;;

esac

for balancer in $loadBalancer;do
  echo "Eliminando $instanceID del loadBalancer $balancer"
  $runAs "elb-deregister-instances-from-lb $balancer --instances $instanceID --access-key-id $AWS_ACCESS_KEY --secret-key $AWS_SECRET_ACCESS_KEY"
done
