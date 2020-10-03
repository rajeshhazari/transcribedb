#!/usr/bin/env bash
set -e
#set -x
echo "$Date Current user ::$USER"
CUR_PATH="${0%/*}"
NOW=$(date +"-%Y/%m/%d %H:%M:%S")
echo "current dir :: " $(pwd)  $NOW
SOLR_IMAGE_NAME=solr:8.5.1
SOLR_APP_DIR=$1
SOLR_DATA_DIR=$2
SOLR_CONF_DIR=$3
SOLR_COLLECTION_NAME=$4
ZK_HOST=$5
ENV=dev
DOCKERNAME=transcribeapp_solr_$ENV
##update 09/01/2020-- updating this script to use docker command to start
#$SOLR_APP_DIR/bin/solr status
#$SOLR_APP_DIR/bin/solr zk upconfig -d $SOLR_CONF_DIR/$SOLR_COLLECTION_NAME/ -n $SOLR_COLLECTION_NAME -z $ZK_HOST
function checkSolrIsRunning() {
  #statements
  EXESTATUS=$(docker exec transcribeapp_solr_dev solr status)
  echo $EXESTATUS
  docker stats $DOCKERNAME
}

if [ -z $SOLR_APP_DIR ]; then
    SOLR_APP_DIR="/opt/apps/solr"
    echo " solr app dir is passed as empty arg defaulting to $SOLR_APP_DIR!"
  elif [ $SOLR_APP_DIR != "/opt/apps/solr" ]; then
      echo " solr app dir is not /opt/apps/solr. exiting!"
      exit -1;
  fi
if [ -d $SOLR_APP_DIR ]; then
  cd $SOLR_APP_DIR
  echo " starting solr docker"
  ##TODO check if solr docker is already started or running
  checkSolrIsRunning
  docker ps -a && docker images && docker run -itd  --restart=always --name transcribeapp_solr_dev -p 8983:8983 -t transcribeapp_solr_dev   -v $SOLR_APP_DIR/solrdata:/var/solr  -v /opt/apps/script/alias.sh:/opt/solr/configs/alias.sh   -v $SOLR_APP_DIR/configs/configs/transcribedb-configs:/opt/solr/configs/transcribedb-configs   -v $SOLR_APP_DIR/configs/configs/:/opt/solr/server/solr/configsets   --env-file solr_env  $SOLR_IMAGE_NAME solr -c -h `$HOSTNAME` -m 2g -f
else
  echo "solr app dir not found.  exiting!"
  exit -1
fi
exit $?
