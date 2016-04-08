scripts
=======

For instances automation


Structure:

|->aws-hostcontainer       #this scripts.
|->configs                 #custom Configurations, placed privatly at S3 required by your applications and not listed at github/bitbucket
|->dockers                 #your dockers-<Enviroment>-compose ymls
|->init.log                #initalization instance log
|->readmeHostContainerServer #this readme :D

This scripts We assumes you have a properly configured IAMRoles, that way no AWS keys are need it.
Also It assumes you use ./misc/etc/rc.local at /etc/rc.local , that way it runs at the begining of your instance initailization.
also ./misc/bucket/config which it's content should be properly configurated and placed at /home/ubuntu/configs.


