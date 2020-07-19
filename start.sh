#! /bin/sh
set -e
#set -x
echo "$Date Current user ::$USER"
CUR_PATH="${0%/*}"
echo "current dir :: " pwd
NOW=`date +"-%Y/%m/%d %H:%M:%S-"`
composefile=$1
if test -f "$composefile"; then
 docker-compose -f $1 up -d
 docker ps
 docker container ls
else
 echo "please mention docker compose file for transcriptiondb docker compose file "
fi
