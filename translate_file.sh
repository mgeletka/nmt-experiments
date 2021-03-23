INPUT_FILE=''
OUTPUT_FILE=''
TOKENIZER_MODEL_PATH=''
CHECKPONT_PATH=''
DATA_BIN_PATH=''

TOKENIZED_FILE=$(basename -- $filename)

spm_encode $INPUT_FILE --model=czeng-bpe.cs-en.32000.model > $TOKENIZED_FILE

cat source.txt | fairseq-interactive  -path $CHECKPONT_PATH | grep -P "D-[0-9]+" | cut -f3 > target.txt

cat  $TOKENIZED_FILE | fairseq-interactive $DATA_BIN_PATH --path $CHECKPONT_PATH | grep -P "D-[0-9]+" | cut -f3 > $OUTPUT_FILE