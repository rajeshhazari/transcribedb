#!/usr/bin/env bash
set -e
set -x
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
CONTAINER_NAME=transcribeapp_solr_$ENV
##update 09/01/2020-- updating this script to use docker command to start
#$SOLR_APP_DIR/bin/solr status
#$SOLR_APP_DIR/bin/solr zk upconfig -d $SOLR_CONF_DIR/$SOLR_COLLECTION_NAME/ -n $SOLR_COLLECTION_NAME -z $ZK_HOST
function checkSolrIsRunning() {
  #statements
  CONTAINER_NAME=$1
  IMAGEID=$SOLR_IMAGE_NAME
  cid="$(docker ps -aq -f  name="$CONTAINER_NAME" )"
  echo $cid
  if [[ ! -z "$cid" ]]; then
    echo "$NAME already running as container $cid: stopping ..."
  else
    echo "$NAME is not started/not running "
    return 0;
  fi

}

function forceStopSolrDockerContainer() {
  #statements
  CONTAINER_NAME=$1

    cid="$(docker ps -aq --filter name="$CONTAINER_NAME" -q)"
    echo $cid
    if [[ ! -z "$cid" ]]; then
        echo "$NAME already running as container $cid: stopping ..."
        ( docker stop $cid > /dev/null && echo Stopped container $cid && \
    docker rm $cid ) 2>/dev/null || true
    fi

    ##check if an exited container blocks, so you can remove it first
    cid="$(docker ps -aq -f status=exited -f status=created -f name=$CONTAINER_NAME )"
    if [[ ! -z $cid ]]; then
        # cleanup called
        docker stop $cid && docker rm $cid
	if [ $? -eq 0 ]; then
	     echo "Stopped and removed container $cid"
	else
	    echo "failed to stop Stop  or remove container $cid"
	    docker ps -a
	fi

        echo "cleanup called :: $CONTAINER_NAME "
    fi

}



## TODO we can make this method generic to any image start
function startImageWithOptions() {
    #statements
    IMAGE_ID=$SOLR_IMAGE_NAME
    ##CONTAINER_NAME=$2
    RUN_OPTIONS="-p 8983:8983 -l $CONTAINER_NAME   -v $SOLR_APP_DIR/solrdata:/var/solr  -v /opt/apps/app-bin:/opt/apps/ -v /opt/apps/solr/configs/solr.in.sh:/etc/default/solr.in.sh   -v $SOLR_APP_DIR/configs/configs/transcribedb-configs:/opt/solr/server/solr/configsets/transcribedb-configs   -v $SOLR_APP_DIR/configs/configs/:/opt/solr/server/solr/configsets   --env-file solr_env  $SOLR_IMAGE_NAME solr -c -h ${HOSTNAME} -m 2g -f "
    docker run -itd  --restart=always --name $CONTAINER_NAME $RUN_OPTIONS

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
  status=$(checkSolrIsRunning $CONTAINER_NAME)
        if [[ ! -z $status ]]; then
            echo -e "\nWARN: Container with name is running $CONTAINER_NAME  . Going to force stop and delete forcefully."
            forceStopSolrDockerContainer $CONTAINER_NAME
	     startImageWithOptions $CONTAINER_NAME
        else
            echo "starting the image in else "
            startImageWithOptions $CONTAINER_NAME
            if [ $? -ne 0 ]; then
                echo -e "\nERROR: Unable to start . Exiting"
                exit 1
            fi
        fi
else
  echo "solr app dir not found.  exiting!"
  exit -1
fi
exit $?
