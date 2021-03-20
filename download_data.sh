#!/bin/bash

# default command line arguments
UFAL_USER=''
UFAL_PASSWORD=''
DATA_DIRECTORY=data/raw-data

# prints help
function usage() {
  echo -e "This downloads and extract all required data for training, validation and testing"
  echo -e ""
  echo -e "./$0"
  echo -e "\t-h --help  prints help"
  echo -e "\t--ufal-user UFAL username for downlaoding CZENG DATA"
  echo -e "\t--ufal-password UFAL password for downlaoding CZENG DATA"
  echo -e "\t-d --data-directory directory to download all data"
}

function info() {
  echo -e "$1"
}

while [ "$1" != "" ]; do
  PARAM=$(echo "$1" | awk -F= '{print $1}')
  VALUE=$(echo "$1" | awk -F= '{print $2}')
  case $PARAM in
  -h | --help)
    usage
    exit
    ;;
  --ufal-password)
    UFAL_PASSWORD=$VALUE
    ;;
  --ufal-user)
    UFAL_USER=$VALUE
    ;;
  -d | --data-directory)
    DATA_DIRECTORY=$VALUE
    ;;
  *)
    echo "ERROR: unknown parameter \"$PARAM\""
    usage
    exit 0
    ;;
  esac
  shift
done

echo
echo "====================Downloading CZENG TRAIN========================="
CZENG_TRAIN_GZ_FILE=$DATA_DIRECTORY/czeng_train.gz
wget http://ufallab.ms.mff.cuni.cz/~bojar/czeng20-data/czeng20-train.gz -O $CZENG_TRAIN_GZ_FILE --user=$UFAL_USER --password=$UFAL_PASSWORD

echo "====================EXTRACTING CZENG TRAIN========================="
gzip -d $CZENG_TRAIN_GZ_FILE



#echo
#echo "====================Downloading CZENG TEST========================="
#CZENG_TEST_GZ_FILE=$DATA_DIRECTORY/czeng_test.gz
#wget http://ufallab.ms.mff.cuni.cz/~bojar/czeng20-data/czeng20-test.gz -O $CZENG_TEST_GZ_FILE --user=$UFAL_USER --password=$UFAL_PASSWORD
#echo "====================EXTRACTING CZENG TEST========================="
#gzip -d $CZENG_TEST_GZ_FILE
#
#
#echo
#echo "====================Downloading NEWSTEST 2019========================="
#NEWSTEST19_TGZ_FILE=$DATA_DIRECTORY/newstest2019.tar
#
#wget http://matrix.statmt.org/test_sets/newstest2019.tgz?1556572561 -O $NEWSTEST19_TGZ_FILE
#
#echo "====================EXTRACTING NEWSTEST 2019========================="
#NEWSTEST19_DIRECTORY=$DATA_DIRECTORY/newstest19
#mkdir $DATA_DIRECTORY/newstest19
#tar -xf $NEWSTEST19_TGZ_FILE -C $NEWSTEST19_DIRECTORY
#
#
#
#echo
#echo "====================Downloading NEWSTEST 2018========================="
#NEWSTEST18_TGZ_FILE=$DATA_DIRECTORY/newstest2018.tar
#wget http://matrix.statmt.org/test_sets/newstest2018.tgz?1527073980 -O $NEWSTEST18_TGZ_FILE
#
#echo "====================EXTRACTING NEWSTEST 2018========================="
#NEWSTEST18_DIRECTORY=$DATA_DIRECTORY/newstest18
#mkdir $DATA_DIRECTORY/newstest18
#tar -xf $NEWSTEST18_TGZ_FILE -C $NEWSTEST18_DIRECTORY
#
#
#echo
#echo "====================Downloading TedTalks 2020========================="
#TEDTALKS_GZ_FILE=$DATA_DIRECTORY/tedtalks.gz
#wget https://opus.nlpl.eu/download.php?f=TED2020/v1/tmx/cs-en.tmx.gz -O $TEDTALKS_GZ_FILE
#
#echo "====================EXTRACTING TedTalks 2020========================="
#gzip -d $TEDTALKS_GZ_FILE
