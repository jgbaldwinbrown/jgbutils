#!/bin/bash
set -e

SWD=`pwd`

gzip -c inter/snpsfile.txt > inter/snpsfile.txt.gz

mkdir inter/treemix/out
cd inter/treemix/out
treemix -i $SWD/inter/snpsfile.txt.gz -o out stem
gunzip -c out.treeout.gz > out.treeout

cp out.treeout $SWD/out/
