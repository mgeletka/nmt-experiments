#!/bin/bash

LOGS_DIRECTORY=outputs.log
DATA_PATH=''
CHECKPOINTS_DIRECTORY=checkpoints
TENSORBOARD_LOGDIR=tensorboard

fairseq-train $DATA_PATH \
  --arch transformer_vaswani_wmt_en_de_big \
  --share-all-embeddings \
  --optimizer adam \
  --adam-betas '(0.9, 0.98)' \
  --clip-norm 0.0 \
  --lr 9.0e-4 \
  --lr-scheduler inverse_sqrt \
  --warmup-updates 4000 \
  --warmup-init-lr 1e-07 \
  --dropout 0.3 \
  --weight-decay 0.0 \
  --criterion label_smoothed_cross_entropy \
  --label-smoothing 0.1 \
  --max-tokens 3584 \
  --fp16 \
  --valid-subset=valid,valid1 \
  --tensorboard-logdir $TENSORBOARD_LOGDIR \
  --save-interval 1 \
  --save-interval-updates 5000 \
  --keep-interval-updates 10 \
  --eval-bleu \
  --update-freq=16 \
  --patience 5 \
  --save-dir $CHECKPOINTS_DIRECTORY &>>$LOGS_DIRECTORY &
