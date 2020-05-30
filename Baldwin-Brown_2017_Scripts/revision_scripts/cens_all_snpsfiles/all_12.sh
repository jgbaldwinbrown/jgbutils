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
    python3 intersect_4fold_subp.py ./4fold_deg_list/shrimp_4fold_degs_10-23-15_sorted_uniq.bed $i ${BASEDIR}/degs 1 2
    python3 make_baypassfile.py ${BASEDIR}/degs.intersected.txt > ${BASEDIR}/degs_snpsfile.txt
    python3 make_baypassfile.py $i > ${BASEDIR}/full_snpsfile.txt
    python3 cens_baypass.py ${BASEDIR}/degs_snpsfile.txt ${BASEDIR}/degs_snpsfile_cens_index.txt > ${BASEDIR}/degs_snpsfile_cens.txt
    python3 cens_baypass.py ${BASEDIR}/full_snpsfile.txt ${BASEDIR}/full_snpsfile_cens_index.txt > ${BASEDIR}/full_snpsfile_cens.txt
done

#../censor_all_snpsfiles/make_baypassfile.py
#./4fold_deg_list/shrimp_4fold_degs_10-23-15_sorted_uniq.bed
#./intersect_4fold_subp.py
#./cens_baypass.py
#./samtools_popoolation/sync2bp.txt
