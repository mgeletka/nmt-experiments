#!/bin/bash

git clone https://github.com/pytorch/fairseq
cd fairseq || exit
pip install --editable ./