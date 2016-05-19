echo killing dockers
for i in $(docker ps|tr -s " "|cut -d' ' -f1|grep -v CON); do echo killing $i && docker kill $i ; done
echo deleting dockers
for i in $(docker ps|tr -s " "|cut -d' ' -f1|grep -v CON); do echo deleting $i && docker rm -f $i ; done
echo deleting images
for i in $(docker images|tr -s " "|cut -d' ' -f3|grep -v IMAGE); do echo Deleting $i && docker rmi -f $i ; done
echo Cleaning unused docker volumes
rm -fr /var/lib/docker/volumes/* /var/run/docker*
