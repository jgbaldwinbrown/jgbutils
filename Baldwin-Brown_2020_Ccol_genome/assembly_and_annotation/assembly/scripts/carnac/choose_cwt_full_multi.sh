#!/bin/bash

set -e
MYHOME=`pwd`

mkdir -p temp/split_minion_rna_for_carnac/choose_cwt_multi
cd temp/split_minion_rna_for_carnac/choose_cwt_multi && \
MYHOME2=`pwd`

for w in 50 100 200 400 ; do
    for m in 10 50 100 200 ; do
        mkdir -p ${w}_${m} && \
        cd ${w}_${m} && \
        find ../../carnac -name '*_clustered.fa.gz' | while read i ; do
            echo "python ${MYHOME}/scripts/carnac/choose_cwt_full.py -t 1 -w ${w} -m ${m} <(gunzip -c $i) | gzip -c > `basename $i .fa.gz`_filt.fa.gz"
        done | \
        parallel -j 8
        cd $MYHOME2
    done
done

cd $MYHOME

touch temp/split_minion_rna_for_carnac/outcarnac_choose_cwt_multi_done.txt

#temp/split_minion_rna_for_carnac/outcarnac_choose_cwt_done.txt

