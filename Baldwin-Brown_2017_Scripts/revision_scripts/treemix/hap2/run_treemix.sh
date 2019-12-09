#!/bin/bash
set -e

SWD=`pwd`

../treemix/baypass2treemix.py inter/snpsfile_12pop_hap2.txt data/pop_order_clean_noquote_nohead.txt > inter/snpsfile_treemix_hap2.txt
gzip -c $SWD/inter/snpsfile_treemix_hap2.txt > $SWD/inter/snpsfile_treemix_hap2.txt.gz
mkdir -p inter/treemix/out_hap2
cd inter/treemix/out_hap2
treemix -i $SWD/inter/snpsfile_treemix_hap2.txt.gz -o out_hap2 stem
gunzip -c out_hap2.treeout.gz > out_hap2.treeout

cp out_hap2.treeout $SWD/out/
python3 $SWD/../treemix/plot.py $SWD/out/out_hap2.treeout $SWD/out/treemix_out_hap2.pdf
