#!/bin/bash

startDate=$(date +%Y%m%d --date="1 year ago")
endDate=$(date +%Y%m%d --date="45 days ago")
script='/usr/local/scripts/elasticsearch/deleteDateRange.sh'

host='https://search-theeye-production-tvqs7qi6yyq7ihiohz3gfxtakm.us-east-1.es.amazonaws.com'
types='agentversion host-stats resource-stats'
field='date'

for index in $(curl --silent "$host/_cat/indices?v"|awk '{print $3}' |grep -v kibana  )                                                           
do  
  echo "cleaning $index"
     for type in $types
     do
       echo -e "\n\nCleaning up host: $host\nindex: $index type: $type field: $field ...\n"
       $script $host $index $type $field $startDate $endDate
     done
done

echo -e "\nDone!"
