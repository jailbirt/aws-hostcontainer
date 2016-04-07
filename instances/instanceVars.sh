#!/bin/bash
source /home/ubuntu/configs/customVars.sh
#Defines location for dockers
dockerPath='/home/ubuntu/dockers/'
#Defines location for scripts
scriptsPath='/home/ubuntu/aws-hostcontainer'
#Defines priv key dest.
keyPath='/home/ubuntu/.ssh'

#Retrieve AWS data.
userData=`/usr/bin/curl -s http://169.254.169.254/latest/user-data`
instanceID=`/usr/bin/curl -s http://169.254.169.254/latest/meta-data/instance-id`
instanceType=`echo $userData | awk '{print $1}'`
imageID=`/usr/bin/curl -s http://169.254.169.254/latest/meta-data/ami-id`
publicHostname=`/usr/bin/curl -s http://169.254.169.254/latest/meta-data/public-hostname`
ipv4=`/usr/bin/curl -s http://169.254.169.254/latest/meta-data/local-ipv4`
publicipv4=`/usr/bin/curl -s http://169.254.169.254/latest/meta-data/public-ipv4`
region=`/usr/bin/curl -s http://169.254.169.254/latest/dynamic/instance-identity/document | grep region | awk -F\" '{print $4}'`
elasticIp=''
loadBalancer=''
#evaluar si cloudwatch o directamente elastic.
#/home/ubuntu/aws-hostcontainer/batch/os/awsLogs.sh staging
dockerEnv=''

printVars () {
   echo "#Instance Variables#
   instanceID: $instanceID
   instanceType: $instanceType
   imageID: $imageID
   publicHostname: $publicHostname
   ipv4: $ipv4
   publicipv4: $publicipv4
   Debug UserData: $userData
   elasticIp: $elasticIp
   maximaCantInstancias=$maximaCantInstancias"
}

echo $userData | grep -qi 'not found'
if [ $(echo $?) -eq 0 ]
then
   instanceType='awsnodes'
fi

instanceType=$(echo $instanceType | cut -d'.' -f1 | sed s/[0-9]//g)

case $instanceType in

  *nodep*)
    loadBalancer=production$codeName\ContainerHosts
    #evaluar si cloudwatch o directamente elastic.
    #/home/ubuntu/aws-hostcontainer/batch/os/awsLogs.sh prod
    dockerEnv=production
  ;;

  *nodes*)
    loadBalancer=staging$codeName\ContainerHosts
    #evaluar si cloudwatch o directamente elastic.
    #/home/ubuntu/aws-hostcontainer/batch/os/awsLogs.sh staging
    dockerEnv=staging
  ;;

  *noded*)
   loadBalancer=demo$codeName\ContainerHosts
   #evaluar si cloudwatch o directamente elastic.
   #/home/ubuntu/aws-hostcontainer/batch/os/awsLogs.sh staging
   dockerEnv=demo
  ;;

  *) ;;

esac

if [ "$1" == '--printvars' ];then printVars ; fi
