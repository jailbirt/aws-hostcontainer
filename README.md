# scripts
=======

For instances automation

```
Structure:

|->aws-hostcontainer       #this scripts.
|->configs                 #custom Configurations, placed privately at S3 required by your applications and not listed at github/bitbucket
|->dockers                 #your dockers-<Enviroment>-compose ymls
|->init.log                #initialization instance log
|->readmeHostContainerServer #this readme :D

```
This scripts assumes you have a properly configured IAMRoles, that way no AWS keys are needed.
Also it assumes you use ./misc/etc/rc.local at /etc/rc.local , that way it runs at the begining of your instance initialization.
also ./misc/bucket/config contents should be properly configurated and placed at /home/ubuntu/configs.


## Start using our empty instance.

AWS Prerequisites:

* 1- Using IAM, please create a role for your instances and attach S3FULLAccess as a policy
* 2- Create your load Balancers, by using: Demo<someCodeName>ContainerHosts
* 2.a <Optional> Create or import your SSL certificates.
* 2.b <Optional> Nginx is installed by default, so you can move forward by opening listeners on: 
    80(tcp) ->81(tcp)
    443(ssl)->80(tcp)
* 3- Launch XXXXX AWS AMI
* 4- Create two S3 buckets:
* 4.1-oneForYourPrivKeys. - Upload your priv key.
* 4.2-oneForYourConfigs.  -Upload your configs with sensible data
* 5- Get into your instance.
* 6- Configure /home/ubuntu/configs/customVars.sh for matching with your params.

