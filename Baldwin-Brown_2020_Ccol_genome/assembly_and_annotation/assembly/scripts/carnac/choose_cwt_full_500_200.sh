mkdir -p temp/split_minion_rna_for_carnac/choose_cwt
MYHOME=`pwd`

cd temp/split_minion_rna_for_carnac/choose_cwt && \
find ../carnac -name '*_clustered.fa.gz' | while read i ; do
    echo "python ${MYHOME}/scripts/carnac/choose_cwt_full.py -w 500 -m 200 <(gunzip -c $i) | gzip -c > `basename $i .fa.gz`_filt.fa.gz"
done | \
parallel -j 8
touch temp/split_minion_rna_for_carnac/outcarnac_choose_cwt_done.txt

#temp/split_minion_rna_for_carnac/outcarnac_choose_cwt_done.txt

