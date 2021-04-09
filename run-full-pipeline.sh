#!/bin/bash


echo '1. phase DOWLOADING DATA'
bash download_data.sh --ufal-user=68ae0c --ufal-password=czeng -d=data/raw-data
echo '2. phase PREPROCESSING DATA'
bash preprocess_data.sh -i=data/raw-data -o=data/preprocessed-data
echo '3. phase PREPROCESSING DATA'
bash tokenize_and_binarize_data.sh --train-files=data/preprocessed-data/train-czeng.en,data/preprocessed-data/train-czeng.cs --input-directory=data/preprocessed-data --tokenized-directory=data/tokenized-data --binarize-directory=data-bin
echo '4. pahse TRAINING'
bash train.sh