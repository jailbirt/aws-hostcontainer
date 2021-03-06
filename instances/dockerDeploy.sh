#!/bin/bash
scriptsPath='/home/ubuntu/aws-hostcontainer'
export HOSTNAME=$(hostname) #Required by web-compose and sockets.
compose="/usr/local/bin/docker-compose"
#Get configs from s3.
$scriptsPath/instances/getConfigs.sh
source $scriptsPath/instances/instanceVars.sh

echo "Getting into $dockerPath"
cd $dockerPath
echo "stopping docker-$dockerEnv-compose.yml"
$compose -f docker-$dockerEnv-compose.yml pull
$compose -f docker-$dockerEnv-compose.yml down 
for i in $(docker ps -a|cut -d ' ' -f1|grep -v CONTA) ; do docker rm $i ; done
echo "cleaning untagged images"
for i in $(docker images | grep "<none>" | awk "{print \$3}") ; do docker rmi $i ; done
echo "Getting new docker-compose files"
git checkout .
git reset --hard
git pull
echo "starting docker-$dockerEnv-compose.yml"
$compose -f docker-$dockerEnv-compose.yml up -d
