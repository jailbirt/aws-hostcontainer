#!/bin/bash
scriptsPath='/home/ubuntu/aws-hostcontainer'
compose=/usr/local/bin/docker-compose
source $scriptsPath/instances/instanceVars.sh

echo "Getting into $dockerPath"
cd $dockerPath
echo "stopping docker-$dockerEnv-compose.yml"
$compose -f docker-$dockerEnv-compose.yml pull
$compose -f docker-$dockerEnv-compose.yml down 
for i in $(docker ps -a|cut -d ' ' -f1|grep -v CONTA) ; do docker rm $i ; done
echo "starting docker-$dockerEnv-compose.yml"
#I'm not interested in stdout. Hopefully I ll configure using other way.
nohup $compose -f docker-$dockerEnv-compose.yml up > /dev/null &
