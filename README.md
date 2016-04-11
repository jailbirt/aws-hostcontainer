# scripts
=======

For instances automation

```
Structure:

|->aws-hostcontainer       #this scripts.
|->configs                 #custom Configurations, placed privatly at S3 required by your applications and not listed at github/bitbucket
|->dockers                 #your dockers-<Enviroment>-compose ymls
|->init.log                #initalization instance log
|->readmeHostContainerServer #this readme :D

```
This scripts We assumes you have a properly configured IAMRoles, that way no AWS keys are need it.
Also It assumes you use ./misc/etc/rc.local at /etc/rc.4local , that way it runs at the begining of your instance initailization.
also ./misc/bucket/config which it's content should be properly configurated and placed at /home/ubuntu/configs.


## Start using our empty instance.

AWS Prerequisites:

* 1- Using IAM, please create a role for your instances and attach S3FULLAccess as a policy
* 2-Create your load Balancers, by using: Demo<someCodeName>ContainerHosts
* 2.a <Optional> create or import your SSL certificates.
* 2.b <Optional> Nginx is installed by default, so you can move forward by opening listeners on: 
    80(tcp) ->81(tcp)
    443(ssl)->80(tcp)
* 3- launch XXXXX AWS AMI
* 4-create two S3 buckets:
* 4.1-oneForYourPrivKeys. - upload your priv key.
* 4.2-oneForYourConfigs.  -upload your configs with sensible data
* 5- get into your instance.
* 6- configure /home/ubuntu/configs/customVars.sh for matching with your params.

