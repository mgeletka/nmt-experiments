#!/bin/bash

TEST_SET='test'
DATA_BIN_DIRECTORY='data-bin'
OUTPUT_FILES_PREFIX='gen_output_${TEST_SET}'
MODEL_PATH=''
TOKENIZE_MODEL_PATH=''


# prints help
function usage() {
  echo -e "This evaluates "
  echo -e ""
  echo -e "./$0"
  echo -e "\t-h --help  prints help"
  echo -e "\t--data-bin data bin directory where the preprocessed test set is saved"
  echo -e "\t--model-path path to checkpoint to evaluate"
  echo -e "\t--output-files-prefix ouput file prefix for generated files"
  echo -e "\t--tokenizer-model tokenizer model for detokenizing"
  echo -e "\t--test-set test set to evaluate (default: test)"
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
  --output-files-prefix)
    OUTPUT_FILES_PREFIX=$VALUE
    ;;
  --tokenizer-model)
    TOKENIZE_MODEL_PATH=$VALUE
    ;;
  --test-set)
    TEST_SET=$VALUE
    ;;
  *)
    echo "ERROR: unknown parameter \"$PARAM\""
    usage
    exit 0
    ;;
  esac
  shift
done

GENERATE_OUTPUT_FILE=${OUTPUT_FILES_PREFIX}.log

CUDA_VISIBLE_DEVICES=1 fairseq-generate $DATA_BIN_DIRECTORY --path $MODEL_PATH --beam 4 --lenpen 0.6 --remove-bpe --gen-subset=$TEST_SET >$GENERATE_OUTPUT_FILE

SYS=$OUTPUT_FILES_PREFIX.sys
REF=$OUTPUT_FILES_PREFIX.ref

grep ^H $GENERATE_OUTPUT_FILE | awk -F '\t' '{print $NF}' | perl -ple 's{(\S)-(\S)}{$1 ##AT##-##AT## $2}g' >$SYS
grep ^T $GENERATE_OUTPUT_FILE | cut -f2- | perl -ple 's{(\S)-(\S)}{$1 ##AT##-##AT## $2}g' >$REF

echo "====================DETOKENIZING RESUTLS========================="
SYS_DETOK=$OUTPUT_FILES_PREFIX.detok.sys
REF_DETOK=$OUTPUT_FILES_PREFIX.detok.ref

spm_decode $SYS --model=$TOKENIZE_MODEL_PATH >$SYS_DETOK
spm_decode $REF --model=$TOKENIZE_MODEL_PATH >$REF_DETOK

echo
echo "====================Results ON " $TEST_SET "========================="
echo '-----------BLEU TOKENIZED-----------'
fairseq-score -s $SYS -r $REF

echo '-----------BLEU_DETOKENIZED_CASED-----------'
fairseq-score -s $SYS_DETOK -r $REF_DETOK

echo '-----------BLEU_DETOKENIZED_IGNORE_CASE-----------'
fairseq-score -s $SYS_DETOK -r $REF_DETOK --ignore-case

echo '-----------SACREBLEU-----------'
cat $SYS_DETOK | sacrebleu $REF_DETOK
