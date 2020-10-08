#!/bin/bash

set -e
SWD=`pwd`
mkdir -p temp/split_minion_rna_for_carnac/chosen_combined/

cd temp/split_minion_rna_for_carnac/choose_cwt/
ls *.fa.gz | python3 scripts/carnac/combine_fa.py | pigz -p 16 -c > ../chosen_combined/all_filt_w500_m200.fa.gz
