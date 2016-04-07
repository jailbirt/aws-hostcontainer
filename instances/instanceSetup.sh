#!/bin/bash
scriptsPath='/home/ubuntu/aws-hostcontainer'
source $scriptsPath/instances/instanceVars.sh --printvars
#Get Priv Key.
/home/ubuntu/aws-hostcontainer/s3/downloadFileFromS3AndDoSomething.js --bucket $bucket --file $file --dest $keyPath --user ubuntu  --group ubuntu --perms 600
cp $keyPath/$file $keyPath/id_rsa
chown ubuntu $keyPath/id_rsa && chmod 600 $keyPath/id_rsa

common() {
  $scriptsPath/instances/createSwapFile.sh
  $scriptsPath/instances/hostname.sh
  $scriptsPath/instances/tagInstance.sh
  $scriptsPath/instances/addDnsRecords.sh
  $scriptsPath/instances/getLastSourceFromGit.sh /home/ubuntu/dockers
  $scriptsPath/instances/addInstanceToBalancer.sh
}

common

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
