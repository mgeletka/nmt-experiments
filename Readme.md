# NMT experiment - BASE- MODEL-CZENG
## Experiment description
In this experiment we trained base vaswani transformer model for machine translation from czech to english
We used same architecture and similar hyperparameters as in this [paper](https://arxiv.org/abs/1806.00187) with it's its [Github](https://github.com/pytorch/fairseq/blob/master/examples/scaling_nmt/README.md)

## Data description
Data used in this experiment:
* TRAINING:
    * czeng_train (data desscription [here](https://ufal.mff.cuni.cz/czeng))
* VALIDATION:
    * newstest 2018 (downloaded from [here](http://matrix.statmt.org/test_sets/newstest2018.tgz?1527073980))
    * tedtalk ( first 10k sentences) (data desciption [here](https://opus.nlpl.eu/TED2020-v1.php))
* TEST
    * newstest 2019 (downloaded from [here](https://opus.nlpl.eu/download.php?f=TED2020/v1/tmx/cs-en.tmx.gz))
    * czeng test 
    * tedtalk (without first 10k sentences)

## Data downloading
For simple of use we provided script for downloading all required data
##### Example of usage
```bash
bash download_data.sh --ufal-user=ufal_username --ufal-password=ufal_password -d=data/raw-data
```

## Data preprocessing
#### Converting to format supported by fairseq
* Firstly we had to convert data from all sources to one format supported by fairseq
* This format is one file per language only with data (no metada) with file ending with shortcut of language (cs, en)
* we implemented this functionality in python script   `preprocess_data.py`
* we wrapped preprocessing of all required files in one shell script
##### Example of usage
```bash
bash preprocess_data.sh -i=data/raw-data -o=data/preprocessed-data
```

#### Tokenization
For tokenization of data we used sentence piece library (documantation [here](https://github.com/google/sentencepiece))
In this experiment we used single dictionary for both language of size 32000 and BPE tokenization algorithm
##### Example of usage (training of tokenizer)
```bash
spm_train --input=first-file-to-train,second-file-to-train  --model_prefix=model-name --vocab_size=32000 --model_type=bpe
```

##### Example of usage (tokenize data)
```bash
spm_encode --model=model-path filename-to-encode > .file-with-tokenized-data
```

#### Binarize data by fairseq
To used our data with fairseq we have preprocess data by fairseq CLI tool fairseq-preprocess.
This tool binarize data and build frequency dictionaries to be used in the training
For detail information refer to [fairseq CLI documentation] (https://fairseq.readthedocs.io/en/latest/command_line_tools.html)


## Train data
To train we used fairseq CLI command `fairseq-train`. For detail hyperparam refer to `train.sh` file.
This whole experiment was executed on single NVIDIA RXT 3080 GPU.

## Model evaluation

### Weight and Biases
For this run we used weight and biases project.
The experiment run is publicly available at this [link](https://wandb.ai/geletka/nmt-cs2en/runs/9qqg4fu9/overview)


### BLEU on test sets
**Computed BLEU scores of final best Model**

| Test set        | Tokenized BLEU | Detokenized BLEU - cased  | Detokenized BLEU | SacreBLEU |
| ------------- |:-------------:| -----:| -----:|  -----:|
| Czeng test      | 44.8 | 37.74 | 38.89| 43.0
| Newstest 2019      | 23.97      |   24.77 | 26.08 |28.8
| TedTalks 2020 | 35.82  |    28.34 | 29.04 |33.2


**Computed BLEU score of Average 5 model** (in this experiment avaraging 5 last checkpoints didn't help)

| Test set        | Tokenized BLEU | Detokenized BLEU - cased  | Detokenized BLEU | SacreBLEU |
| ------------- |:-------------:| -----:| -----:|  -----:|
| Czeng test      | 44.7 | 37.7 | 38.85| 43.0
| Newstest 2019      | 29.27      |   24.89 | 26.26|27.7
| TedTalks 2020 | 35.49  | 28.17 | 28.87 |33.0
