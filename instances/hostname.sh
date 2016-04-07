#!/bin/bash                                                                                                                                                                                                      
source /home/ubuntu/aws-hostcontainer/instances/instanceVars.sh

instancesRunningTags=$(ec2-describe-instances --filter instance-state-code=16 |grep TAG |grep $instanceType)

#Auto Name Instances
for i in $(seq 1 $maximaCantInstancias); do
  host=$instanceType'0'$i
  echo "probando nombre $host"
  echo $instancesRunningTags |grep $host
  if [ $? -eq 1 ];then
   echo "Ok nombre $host Disponible"
   shorthostname="$host"
   host="$host"."$domainName"
   break
  else
   host=''
  fi
done

if [ "$host" == "" ];then
 echo "alcanzaste el tamaño maximo de instancia $instanceType"
 exit
fi

#Set the host name
hostname $host
echo $host > /etc/hostname

#Add fqdn to hosts file
echo " This file is automatically genreated by ec2-hostname script
127.0.0.1 $host $shorthostname localhost
$ipv4 $host $shorthostname

The following lines are desirable for IPv6 capable hosts
::1 ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
ff02::3 ip6-allhosts" > /etc/hosts

fqdn=$(hostname -f)

echo $fqdn | grep -q ".*aws.*"

if [ $(echo $?) -ne '0' ];then

  imageName=$(echo $imageDesc | awk '{print $1}')

  echo "La instancia no seteo correctamente su hostname y fue terminada

InstanceID: $instanceType 

InstanceType: $instanceType

ImageName: $imageName

User-data: $userData

Hostname: $fqdn" | mail -s "Hostname Error launching instance: $instanceID ami: $imageID" $notify

  echo "Hostname error, terminando instancia..."
  $runAs "ec2-modify-instance-attribute $instanceID --disable-api-termination false"
  $runAs "ec2-terminate-instances $instanceID"

fi

/usr/bin/service postfix restart
