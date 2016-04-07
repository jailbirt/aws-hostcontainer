#!/bin/bash

path=$1
oldPath=$(pwd)

echo Getting $path .... 

if [ -z $path ];then echo "Run $0 path"; exit ; fi
if [ ! -d $path ];then echo "Path > '$path' is not a directory, bye!" ; exit ; fi

user=$(ls -ld $path | awk '{print $3}')
runAs="sudo su - $user -c"

echo "changing perms at $path"
chown -R ubuntu $path

echo -e "\ngit pull | user: $user path: $path\n"
$runAs "cd $path && git reset --hard HEAD && git clean -fd && git pull"
status=$?
cd $oldPath

if [ $status -eq 0 ]
then
  echo -e "\ngit pull | user: $user path: $path status: success"
else
  echo -e "\ngit pull | user: $user path: $path status: failure"
fi
