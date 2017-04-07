#!/bin/bash
scriptsPath='/home/ubuntu/aws-hostcontainer'
aws='/usr/bin/aws'
dockerDaemonStatus='off'
source $scriptsPath/instances/instanceVars.sh --printvars
#Get Priv Key.
echo Getting Private Files... 
echo Get Your Private Key.
echo $aws s3 cp s3://$privKeybucket/$privKey $keyPath/id_rsa
$aws s3 cp s3://$privKeybucket/$privKey $keyPath/id_rsa
chmod 600 $keyPath/id_rsa
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
  $customScriptsPath/mounts.sh
  $scriptsPath/instances/addInstanceToBalancer.sh
}

common

#Temporal
cp -pr /home/ubuntu/configs/etc/nginx/* /etc/nginx/
service nginx reload
cp /home/ubuntu/configs/etc/logorate.d/* /etc/logrotate.d/

echo "Please wait until docker socket is ready"
#Wait until docker service is ready
while [ $dockerDaemonStatus != 'on' ]
do
  echo "Waiting 5 seconds for docker daemon..."
  timeout 5 docker ps
  status=$?
	
  if [ $status -eq 0 ]
  then 
    dockerDaemonStatus='on'
    echo "Docker daemon ready"
  fi

done

echo "Cleaning dockers unused volumes"
$scriptsPath/docker/dockerCleanUp.sh

echo "Running Deploy"
sudo su - ubuntu -c "$scriptsPath/instances/dockerDeploy.sh"

echo "initializing HostContainer Env:$dockerEnv,
     data: $instanceType $imageID $imageDesc" | mail -s "Initializing DockerHost Container Env:$dockerEnv " $notify

if [ -f /home/ubuntu/configs/customConfigs.sh ];then
  echo "Running configs/custom.sh"
  bash /home/ubuntu/configs/customConfigs.sh $instanceType
fi
true
