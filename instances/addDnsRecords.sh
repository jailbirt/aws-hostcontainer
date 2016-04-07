#!/bin/bash

source /home/ubuntu/aws-hostcontainer/instances/instanceVars.sh
cli=/usr/local/bin/cli53

host=$(hostname -f | cut -d. -f1)
zone=$domainName
if [ -z $cli ];then echo "ERROR. cli53 not installed" ; exit ; fi

args="--replace -x 300"

echo "Asociando de $fqdn a $publicHostname"
echo "doing cli:$cli args:$args zone:$zone host:$host rtype:CNAME record:$publicHostname"
eval $cli rrcreate $zone $host CNAME $publicHostname $args
