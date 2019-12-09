#!/bin/bash
#$ -N cens
#$ -pe openmp 1
#$ -R y
#$ -q bio,pub64,abio,free64,free48
#$ -ckpt restart

module load bedtools
module load python/3.6.1
module unload python/2.7.2

set -e
cd $SGE_O_WORKDIR

#for i in ./samtools_popoolation/sync2freq2.txt
for i in ./haplocaller_200ploid/out2.txt ./haplocaller_2ploid/out2.txt ./samtools_popoolation/sync2freq2.txt
do
    BASEDIR=`dirname $i`
    BASENAME=`basename $i .txt`
    python3 intersect_4fold_subp_ld.py ./4fold_deg_list/shrimp_4fold_degs_10-23-15_sorted_uniq.bed $i ${BASEDIR}/degs_ld 1 2 100000
    python3 make_baypassfile.py ${BASEDIR}/degs_ld.ldfilt.intersected.txt > ${BASEDIR}/degs_ld_snpsfile.txt
    python3 cens_baypass.py ${BASEDIR}/degs_ld_snpsfile.txt ${BASEDIR}/degs_ld_snpsfile_cens_index.txt > ${BASEDIR}/degs_ld_snpsfile_cens.txt
done

j=old_correct/snpsfile_12pop_degs.txt

BASEDIR=`dirname $j`
BASENAME=`basename $j .txt`

python3 bayenv2baypass.py ${j} > ${BASEDIR}/degs_ld_snpsfile.txt

python3 cens_baypass.py ${BASEDIR}/degs_ld_snpsfile.txt ${BASEDIR}/degs_ld_snpsfile_cens_index.txt > ${BASEDIR}/degs_ld_snpsfile_cens.txt

set -e
cd $SGE_O_WORKDIR

cat biglist_ld.txt | while read line
do
    outpath=`dirname $line`/`basename $line .txt`_11.txt
    cat $line | python3 add_last_to_first.py > $outpath
done
