#!/bin/bash
scriptsPath='/home/ubuntu/aws-hostcontainer'
aws='/usr/bin/aws'
source $scriptsPath/instances/instanceVars.sh --printvars
#Get Priv Key.
echo Getting Private Files... 
echo Get Your Private Key.
echo $aws s3 cp s3://$privKeybucket/$privKey $keyPath/id_rsa
$aws s3 cp s3://$privKeybucket/$privKey $keyPath/id_rsa
ssh-keygen -y -f $keyPath/id_rsa > $keyPath/id_rsa.pub
cat $keyPath/id_rsa.pub >> $keyPath/authorized_keys
chown ubuntu $keyPath/* && chmod 600 $keyPath/*
#Get dockerHub credentials
mkdir -p /home/ubuntu/.docker
$aws s3 cp s3://$privKeybucket/docker_config.json /home/ubuntu/.docker/config.json
chown -R ubuntu /home/ubuntu/.docker

#Get Your Configurations.
$scriptsPath/instances/getConfigs.sh

common() {
  $scriptsPath/instances/createSwapFile.sh
  $scriptsPath/instances/hostname.sh
  $scriptsPath/instances/tagInstance.sh
  $scriptsPath/instances/addDnsRecords.sh
  $scriptsPath/instances/getLastSourceFromGit.sh /home/ubuntu/dockers
  $scriptsPath/instances/updateCodePaths.sh
  $scriptsPath/instances/addInstanceToBalancer.sh
}

common

#Temporal
cp -pr /home/ubuntu/configs/etc/nginx/* /etc/nginx/
service nginx reload
cp /home/ubuntu/configs/etc/logorate.d/* /etc/logrotate.d/

echo "Cleaning dockers unused volumes"
$scriptsPath/docker/dockerCleanUp.sh

echo "Please wait until docker socket is ready"
#Wait until docker service is ready
while ! [ -e /var/run/docker.sock ]; do
  echo "*"
  sleep 0.1
done
echo "Running Deploy"
sudo su - ubuntu -c "$scriptsPath/instances/dockerDeploy.sh"

echo "initializing HostContainer Env:$dockerEnv,
     data: $instanceType $imageID $imageDesc" | mail -s "Initializing DockerHost Container Env:$dockerEnv " $notify

true
