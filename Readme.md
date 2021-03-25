# NMT experiment - BASE- MODEL-CZENG
## Experiment description
In this experiment we trained base vaswani transformer model for machine transloation from czech to english
We used same architecture and similar hyperparameters as in this [paper](https://arxiv.org/abs/1806.00187) with it's its [Github](https://github.com/pytorch/fairseq/blob/master/examples/scaling_nmt/README.md)

## Data description
For this first experiment we trained our model on paralel corpus of en-cs open subtitles available [here](https://opus.nlpl.eu/OpenSubtitles-v2018.php)
* TRAINING:
  * 80% of available opensubtitles dataset
* VALIDATION:
  * 10% of available opensubtitles dataset
* TEST
  * 10% of available opensubtitles dataset


## Data downloading
TODO

## Data preprocessing

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
For detail information refer to [fairseq CLI documentation](https://fairseq.readthedocs.io/en/latest/command_line_tools.html)


## Train data
To train we used fairseq CLI command `fairseq-train`. For detail hyperparam refer to `train.sh` file.
This whole experiment was executed on single NVIDIA RXT 3080 GPU.

## Model evaluation

### Tensorboard
To see detail of this particular experimetn run please download tensorboard directory in this branch and run
(You must have active virtualenv with installed tensorboard)
```bash
tensorboard --logdir=tensorboard
```

### BLEU on test sets
**Computed BLEU scores of final best Model**

| Test set        | Tokenized BLEU | Detokenized BLEU - cased  | Detokenized BLEU | SacreBLEU |
| ------------- |:-------------:| -----:| -----:|  -----:|
| Czeng test      | X | X | X|X
| Newstest 2019      | X      |   X | X|X
| Newstest from sacremoses (origlang en)     | X     |   X | X| X
| TedTalks 2020 | X  |    X | X|X


**Computed BLEU score of Average 5 model**

| Test set        | Tokenized BLEU | Detokenized BLEU - cased  | Detokenized BLEU | SacreBLEU |
| ------------- |:-------------:| -----:| -----:|  -----:|
| Czeng test      | X | X | X|X
| Newstest 2019      | X      |   X | X|X
| Newstest from sacremoses (origlang en)     | X     |   X | X| X
| TedTalks 2020 | X  |    X | X|X