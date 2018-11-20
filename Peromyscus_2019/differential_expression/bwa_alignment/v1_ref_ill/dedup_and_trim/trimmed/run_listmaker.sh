#!/bin/bash
#$ -N listmaker
#$ -q bio,abio,adl,free64,pub64
#$ -ckpt restart
#$ -hold_jid prinseq

mypwd=`pwd`

cd .. && find $PWD -maxdepth 1 -size +1M -name '*.gz' | grep 'good' | sort > $mypwd/rnaseq_paths_sorted.txt

