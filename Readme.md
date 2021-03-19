# NMT experiment - BASE- MODEL-CZENG
## Experiment description
In this experiment we trained base vaswani transformer model for machine transloation from czech to english
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

#### Train tokenizer and tokenized data
TODO
#### Binarize data by fairseq
TODO
#### Example of usage
TODO
```bash
```



## Train data
TODO

## Data evaluation
TODO
