#!/bin/bash

OUTPUT_TRANSLATED_FILE=''
TOKENIZER_MODEL_PATH=''
MODEL_PATH=''
DATA_BIN_DIRECTORY=''
SYS_FILE=''
REF_FILE=''
OUTPUT_TRANSLATED_FILE=''

# prints help
function usage() {
  echo -e "This evaluates "
  echo -e ""
  echo -e "./$0"
  echo -e "\t-h --help  prints help"
  echo -e "\t--sys-file sys file to translate"
  echo -e "\t--ref-file ref file to compare the translation"
  echo -e "\t--output-translated-file path to file where translete sys file"
  echo -e "\t--model-path path to checkpoint to evaluate"
  echo -e "\t--tokenizer-model tokenizer model for detokenizing"
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
  --data-bin)
    DATA_BIN_DIRECTORY=$VALUE
    ;;
  --model-path)
    MODEL_PATH=$VALUE
    ;;
  --output-translated-file)
    OUTPUT_TRANSLATED_FILE=$VALUE
    ;;
  --sys-file)
    SYS_FILE=$VALUE
    ;;
  --ref-file)
    REF_FILE=$VALUE
    ;;
  --tokenizer-model)
    TOKENIZER_MODEL_PATH=$VALUE
    ;;
  *)
    echo "ERROR: unknown parameter \"$PARAM\""
    usage
    exit 0
    ;;
  esac
  shift
done


bash translate_file.sh --input-file=$SYS_FILE --output-file=$OUTPUT_TRANSLATED_FILE --model-path=$MODEL_PATH --data-bin=$DATA_BIN_DIRECTORY --tokenizer-model=$TOKENIZER_MODEL_PATH

echo "====================Results WITH " $SYS_FILE "and " $REF_FILE"========================="

echo '-----------BLEU_DETOKENIZED_CASED-----------'
fairseq-score -s $OUTPUT_TRANSLATED_FILE -r $REF_FILE

echo '-----------BLEU_DETOKENIZED_IGNORE_CASE-----------'
fairseq-score -s $SYS_FILE -r $REF_FILE --ignore-case

echo '-----------SACREBLEU-----------'
cat $SYS_FILE | sacrebleu $REF_FILE
