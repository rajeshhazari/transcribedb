
#! /bin/sh
set -e
set -x
echo "$Date Current user ::$USER"
CUR_PATH="${0%/*}"
pwd
NOW=`date +"-%Y/%m/%d %H:%M:%S-"`
composefile=$1
if test -f "$composefile"; then
 #docker-compose -f $1 up -d
 NODE_ENV=dev; NAME=transcribeapp_db; VERSION=1.0.0; docker-compose -f $1 up  -d
 docker ps
 docker container ls
else
 echo "please mention docker compose file for transcriptiondb docker compose file "
fi
