#!/bin/bash
set -e

SWD=`pwd`

bash ../treemix/run_baypass2treemix.sh
gzip -c inter/snpsfile.txt > inter/snpsfile.txt.gz

mkdir -p inter/treemix/out
cd inter/treemix/out
treemix -i $SWD/inter/snpsfile.txt.gz -o out stem
gunzip -c out.treeout.gz > out.treeout

cp out.treeout $SWD/out/
