for i in $(docker images|tr -s " "|cut -d' ' -f3|grep -v IMAGE); do docker rmi $i ; done
