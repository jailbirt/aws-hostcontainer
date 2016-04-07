#!/bin/bash

host=$1
index=$2
type=$3
field=$4
startDate=$5
endDate=$6

if [ $# -ne 6 ];then 
  echo "Run $0 host index type field startDate endDate" 
  echo "Date format yyyymmdd"
  exit 
fi

for date in $startDate $endDate
do

  echo $date | grep -qE "[0-9]{8}"
  status=$?
  if [ $status -ne 0 ];then echo "Wrong date format: $date" ; exit ; fi

done

#Date format for elasticsearch query yyyy-mm-dd
startDate="${startDate:0:4}-${startDate:4:2}-${startDate:6:2}"
endDate="${endDate:0:4}-${endDate:4:2}-${endDate:6:2}"

query='{
  "query": {

    "filtered":{
      "filter" :{
        "range" :{
          "FIELD" : {
            "gte": "STARTDATE",
            "lte": "ENDDATE"
          }
        }
       }
     }
   }
}'

query=$(echo -e "$query" | sed -e "s/STARTDATE/$startDate/" -e "s/ENDDATE/$endDate/" -e "s/FIELD/$field/" )

echo -e "Executing query...\n$query"

curl -XDELETE $host/$index/$type/_query -d "$query"
