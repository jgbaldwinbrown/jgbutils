#!/bin/bash
#$ -N cens_old_correct
#$ -pe openmp 1
#$ -R y
#$ -q bio,pub64,abio,free64,free48
#$ -ckpt restart

module load bedtools
module load python/3.6.1
module unload python/2.7.2

set -e
cd $SGE_O_WORKDIR

i=old_correct/snpsfile_12pop_bp.txt
j=old_correct/snpsfile_12pop_degs.txt

BASEDIR=`dirname $i`
BASENAME=`basename $i .txt`

python3 bayenv2baypass.py ${j} > ${BASEDIR}/degs_snpsfile.txt
cp $i ${BASEDIR}/full_snpsfile.txt

python3 cens_baypass.py ${BASEDIR}/degs_snpsfile.txt ${BASEDIR}/degs_snpsfile_cens_index.txt > ${BASEDIR}/degs_snpsfile_cens.txt
python3 cens_baypass.py ${BASEDIR}/full_snpsfile.txt ${BASEDIR}/full_snpsfile_cens_index.txt > ${BASEDIR}/full_snpsfile_cens.txt

cat out_correct_list.txt | while read line
do
    outpath=`dirname $line`/`basename $line .txt`_11.txt
    cat $line | python3 add_last_to_first.py > $outpath
done

# old_correct/snpsfile_12pop.txt
# old_correct/snpsfile_12pop_bp.txt
# old_correct/snpsfile_12pop_degs.txt
