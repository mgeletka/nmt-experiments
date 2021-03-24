#!/bin/bash


INPUT_FILE=''
OUTPUT_FILE=''
TOKENIZER_MODEL_PATH=''
MODEL_PATH=''
DATA_BIN_DIRECTORY=''

TOKENIZED_INPUT_FILE=$INPUT_FILE.tokenized
TRANSLATED_TOK=$INPUT_FILE.tokenized.translated

# prints help
function usage() {
  echo -e "This evaluates "
  echo -e ""
  echo -e "./$0"
  echo -e "\t-h --help  prints help"
  echo -e "\t--input-file  input file to translate by selected model"
    echo -e "\t--output-file  output filename with translated text"
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
  --output-file)
    OUTPUT_FILE=$VALUE
    ;;
  --input-file)
    INPUT_FILE=$VALUE
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



spm_encode $INPUT_FILE --model=$TOKENIZER_MODEL_PATH > $TOKENIZED_INPUT_FILE
cat  $TOKENIZED_INPUT_FILE | fairseq-interactive $DATA_BIN_DIRECTORY --path $MODEL_PATH --remove-bpe | grep -P "D-[0-9]+" | cut -f3 > $TRANSLATED_TOK
spm_decode $TRANSLATED_TOK --model=$TOKENIZER_MODEL_PATH > $OUTPUT_FILE