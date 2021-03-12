
#!/usr/bin/env bash
set -e
set -x
echo "$Date Current user ::$USER"
CUR_PATH="${0%/*}"
NOW=$(date +"-%Y/%m/%d %H:%M:%S")
echo "current dir :: " $(pwd)  $NOW
SOLR_CREATE_COLLECTIONS=$1
SOLR_INSTALL_DIR=$2
SOLR_DATA_DIR=$3
SOLR_CONF_DIR=$4
SOLR_COLLECTION_NAME=$5
ZK_HOST=$6
ENV=dev

if [ -z $SOLR_INSTALL_DIR ]; then
    SOLR_INSTALL_DIR="/opt/solr"
    echo " solr install dir is passed as empty arg defaulting to SOLR_INSTALL_DIR:: $SOLR_INSTALL_DIR!"
  elif [ $SOLR_INSTALL_DIR != "/opt/solr" ]; then
      echo " solr install dir is not found /opt/solr. exiting!"
    exit -1;
fi
if [ -z $SOLR_CONF_DIR ]; then
  SOLR_CONF_DIR="/opt/solr/server/solr/configsets/"
  echo " solr configs dir is passed as empty arg defaulting to SOLR_CONF_DIR:: $SOLR_CONF_DIR!"
elif [ $SOLR_CONF_DIR != "/opt/solr/server/solr/configsets" ]; then
    echo " solr conf dir is not found /opt/solr/server/solr/configsets exiting!"
  exit -1;
fi
if [ -z $SOLR_COLLECTION_NAME ]; then

fi

if [[ ! -z $SOLR_CREATE_COLLECTIONS && "$SOLR_CREATE_COLLECTIONS" == "create" ]]; then
    echo "creating solr collections from the configs uploaded into to docker container."
    if [ -d $SOLR_APP_DIR ]; then
      cd $SOLR_APP_DIR
      echo " starting upload of configs and collection creations "
      $SOLR_INSTALL_DIR/bin/solr status

      $SOLR_INSTALL_DIR/bin/solr zk upconfig -d $SOLR_CONF_DIR/$SOLR_COLLECTION_NAME/ -n $SOLR_COLLECTION_NAME -z $ZK_HOST

    else
      echo "solr app dir not found.  exiting!"
      exit -1
    fi
  else
      ##TODO another stuff like check collection status
      $SOLR_INSTALL_DIR/bin/solr status
  fi
exit $?
