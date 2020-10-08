#!/bin/bash

set -e
SWD=`pwd`
mkdir -p temp/split_minion_rna_for_carnac/chosen_combined_multi

for w in 50 100 200 400 ; do
    for m in 10 50 100 200 ; do
        cd $SWD
        mkdir -p temp/split_minion_rna_for_carnac/chosen_combined_multi/${w}_${m}
        cd ${SWD}/temp/split_minion_rna_for_carnac/choose_cwt_multi/${w}_${m}
        ls *.fa.gz | \
        python3 ${SWD}/scripts/carnac/combine_fa.py | \
        pigz -p 16 -c \
        > ../../chosen_combined_multi/${w}_${m}/all_filt_w${w}_m${m}.fa.gz
    done
done
