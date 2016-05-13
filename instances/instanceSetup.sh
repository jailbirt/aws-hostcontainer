#!/bin/bash
scriptsPath='/home/ubuntu/aws-hostcontainer'
aws='/usr/bin/aws'
source $scriptsPath/instances/instanceVars.sh --printvars
#Get Priv Key.
echo Getting Private Files... 
echo Get Your Private Key.
echo $aws s3 cp s3://$privKeybucket/$privKey $keyPath
$aws s3 cp s3://$privKeybucket/$privKey $keyPath
cp $keyPath/$file $keyPath/id_rsa
chown ubuntu $keyPath/id_rsa && chmod 600 $keyPath/id_rsa
#Get Your Configurations.
$scriptsPath/instances/getConfigs.sh

common() {
  $scriptsPath/instances/createSwapFile.sh
  $scriptsPath/instances/hostname.sh
  $scriptsPath/instances/tagInstance.sh
  $scriptsPath/instances/addDnsRecords.sh
  $scriptsPath/instances/getLastSourceFromGit.sh /home/ubuntu/dockers
  $scriptsPath/instances/addInstanceToBalancer.sh
}

common

#Temporal
cp /home/ubuntu/configs/nginx_default /etc/nginx/sites-available/default

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
