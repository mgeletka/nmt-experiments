#!/bin/bash

TRAIN_FILES=''
TOKENIZED_DATA_DIRECTORY=''
INPUT_DATA_DIRECTORY=''
BINARIZE_DATA_DIRECTORY=''

MODEL_PREFIX=tokenizer/bpe.cs-en.32000
VOCABULARY_SIZE=32000
TOKENIZATION_TYPE=bpe

# prints help
function usage() {
  echo -e "This scribt trains sentecepiece tokenizer on training data, then tokenize data by this model and final binarize data by fairseq preprocess"
  echo -e ""
  echo -e "./$0"
  echo -e "\t-h --help  prints help"
  echo -e "\t--train-files files to train tokenizer (comma seperated)"
  echo -e "\t--input-directory input directory where are not tokenized"
  echo -e "\t--tokenized-directory output directory where we save tokenzied data"
  echo -e "\t--binarize-directory directory where we save binarized data"
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
  --train-files)
    TRAIN_FILES=$VALUE
    ;;
  --input-directory)
    INPUT_DATA_DIRECTORY=$VALUE
    ;;
  --tokenized-directory)
    TOKENIZED_DATA_DIRECTORY=$VALUE
    ;;
  --binarize-directory)
    BINARIZE_DATA_DIRECTORY=$VALUE
    ;;
  *)
    echo "ERROR: unknown parameter \"$PARAM\""
    usage
    exit 0
    ;;
  esac
  shift
done

source venv/bin/activate
#echo "====================TRAINING TOKENIZER========================="
#spm_train --input=$TRAIN_FILES --model_prefix=$MODEL_PREFIX --vocab_size=$VOCABULARY_SIZE --model_type=$TOKENIZATION_TYPE

echo "====================TOKENIZING DATA========================="
for filename in $INPUT_DATA_DIRECTORY/*; do
  echo "TOKENIZING " $filename
  spm_encode --model=$MODEL_PREFIX.model $filename >$TOKENIZED_DATA_DIRECTORY/$(basename -- $filename)
done

#echo "====================BINARIZE DATA========================="
#fairseq-preprocess --source-lang en \
#  --target-lang cs \
#  --trainpref $TOKENIZED_DATA_DIRECTORY/train-czeng \
#  --validpref $TOKENIZED_DATA_DIRECTORY/validation-newstest2018,$TOKENIZED_DATA_DIRECTORY/validation-tedtalks \
#  --testpref $TOKENIZED_DATA_DIRECTORY/test-czeng,$TOKENIZED_DATA_DIRECTORY/test-newstest2019,$TOKENIZED_DATA_DIRECTORY/test-tedtalks \
#  --destdir $BINARIZE_DATA_DIRECTORY \
#  --nwordssrc 32768 \
#  --nwordstgt 32768 \
#  --joined-dictionary \
#  --workers 20
