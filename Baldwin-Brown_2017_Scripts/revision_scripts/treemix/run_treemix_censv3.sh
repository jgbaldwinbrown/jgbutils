#!/bin/bash
set -e

SWD=`pwd`

bash ../treemix/run_baypass2treemix.sh
gzip $SWD/inter/snpsfile_treemix.txt > $SWD/inter/snpsfile_treemix.txt.gz
mkdir -p inter/treemix/out
cd inter/treemix/out
treemix -i $SWD/inter/snpsfile_treemix.txt.gz -o out stem
gunzip -c out.treeout.gz > out.treeout

cp out.treeout $SWD/out/
