echo killing dockers
for i in $(docker ps|tr -s " "|cut -d' ' -f1|grep -v CON); do echo killing $i && docker kill $i ; done
echo deleting dockers
for i in $(docker ps|tr -s " "|cut -d' ' -f1|grep -v CON); do echo deleting $i && docker rm -f $i ; done
echo cleaning untagged images
for i in $(docker images | grep "<none>" | awk "{print \$3}") ; do docker rmi -f $i ; done
echo Cleaning unused docker volumes
rm -fr /var/lib/docker/volumes/* /var/run/docker*
service docker restart
