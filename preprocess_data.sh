#!/bin/bash


# default command line arguments
INPUT_DATA_DIRECTORY=data/raw-data
OUTPUT_DATA_DIRECTORY=data/preprocessed-data


# prints help
function usage()
{
    echo -e "This preprocess required data for training, validation and testing into format expected in fairseq for binarization"
    echo -e ""
    echo -e "./$0"
    echo -e "\t-h --help  prints help"
    echo -e "\t-i --input-directory directory with downloaded all raw data"
    echo -e "\t-o --output-directory directory to save all preprocessed data"
}

function info
{
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
        -i | --input-directory)
            INPUT_DATA_DIRECTORY=$VALUE
            ;;
        -o | --output-directory)
            OUTPUT_DATA_DIRECTORY=$VALUE
            ;;
        *)
            echo "ERROR: unknown parameter \"$PARAM\""
            usage
            exit 0
            ;;
    esac
    shift
done

## Create python environment and activate it
python3 -m venv venv
source venv/bin/activate


### Install  python requirements
pip install -r requirements.txt


## Preprocess data to fairseq format
## preprocess first 10k lines of TEDTALK as validation set
echo ;echo "====================PREPROCESSING TEDTALK VALIDATION========================="
python preprocess_data.py --source-lang=cs\
                            --target-lang=en \
                            --type-of-file tedtalks \
                            --input-path=$INPUT_DATA_DIRECTORY/tedtalks \
                            --output-prefix=$OUTPUT_DATA_DIRECTORY/validation-tedtalks \
                            --take-to-sentence=10000
#
### preprocess TEDTALK without first 10k lines as test set
echo ;echo "====================PREPROCESSING TEDTALK TEST========================="
python preprocess_data.py --source-lang=cs\
                            --target-lang=en \
                            --type-of-file tedtalks \
                            --input-path=$INPUT_DATA_DIRECTORY/tedtalks \
                            --output-prefix=$OUTPUT_DATA_DIRECTORY/test-tedtalks \
                            --take-from-sentence=10000

## preprocess newstest2018
echo ;echo "====================PREPROCESSING NEWSTEST 2018 VALIDATION========================="
python preprocess_data.py --source-lang=cs\
                            --target-lang=en \
                            --type-of-file newstest18 \
                            --input-path=$INPUT_DATA_DIRECTORY/newstest18/test/newstest2018-csen \
                            --output-prefix=$OUTPUT_DATA_DIRECTORY/validation-newstest2018


## preprocess newstest2019
echo ;echo "====================PREPROCESSING NEWSTEST 2019 TEST========================="
python preprocess_data.py --source-lang=cs\
                            --target-lang=en \
                            --type-of-file newstest19 \
                            --input-path=$INPUT_DATA_DIRECTORY/newstest19/sgm/newstest2019-csen \
                            --output-prefix=$OUTPUT_DATA_DIRECTORY/test-newstest2019


## preprocess czeng test
echo ;echo "====================PREPROCESSING CZENG TEST========================="
python preprocess_data.py --source-lang=cs\
                            --target-lang=en \
                            --type-of-file czeng \
                            --input-path=$INPUT_DATA_DIRECTORY/czeng_test \
                            --output-prefix=$OUTPUT_DATA_DIRECTORY/test-czeng

## preprocess czeng train
echo ;echo "====================PREPROCESSING CZENG TRAIN========================="
python preprocess_data.py --source-lang=cs\
                            --target-lang=en \
                            --type-of-file czeng \
                            --input-path=$INPUT_DATA_DIRECTORY/czeng_train \
                            --output-prefix=$OUTPUT_DATA_DIRECTORY/train-czeng

