#!/bin/bash

if [ "$#" -ne '3' ];then echo "use $0 recordType(cname|a|spf) hostname record(ip|hostname)" ; exit ; fi

cli=$(which cli53)
if [ -z $cli ];then echo "ERROR. cli53 not installed" ; exit ; fi

args="rrcreate --replace --ttl 300"
rtype=$1
record=$3

case $rtype in
  cname|CNAME)
    rtype='CNAME'
    ;;
  a|A)
    rtype='A'
    ;;
  spf|SPF)
    rtype='SPF'
    record=\'\"$record\"\'
    ;;
  ptr|PTR)
    rtype='PTR'
    record=\'\"$record\"\'
    ;;
  *)
    echo "unknown record type, bye"
    exit
esac

echo "doing cli:$cli args:$args zone:$zone host:$host rtype:CNAME record:$record"

eval $cli $args $zone $host $rtype $record

echo "done. bye"
