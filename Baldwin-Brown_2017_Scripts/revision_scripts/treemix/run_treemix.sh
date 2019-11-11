#!/bin/bash
set -e

SWD=`pwd`

../treemix/baypass2treemix.py inter/snpsfile_12pop_censv3.txt data/pop_order.txt > inter/snpsfile_treemix_censv3.txt
gzip $SWD/inter/snpsfile_treemix_censv3.txt > $SWD/inter/snpsfile_treemix_censv3.txt.gz
mkdir -p inter/treemix/out
cd inter/treemix/out
treemix -i $SWD/inter/snpsfile_treemix_censv3.txt.gz -o out_censv3 stem
gunzip -c out_censv3.treeout.gz > out_censv3.treeout

cp out_censv3.treeout $SWD/out/

