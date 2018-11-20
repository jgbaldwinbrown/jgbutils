#!/bin/bash
#$ -N re_pair
#$ -q bio,abio,pub64,free64,adl,pub8i
#$ -ckpt restart
#$ -hold_jid trimmomatic
#$ -pe openmp 1
#$ -t 1-35

jobnum=$SGE_TASK_ID
rindex2=`echo "$jobnum * 2" | bc | tr -d '\n'`
rindex1=`echo "$rindex2 - 1" | bc | tr -d '\n'`
fq1=`head -n $rindex1 all_pinput.txt | tail -n 1`
fq2=`head -n $rindex2 all_pinput.txt | tail -n 1`

mkdir -p repaired

python get_paired_fq.py $fq1 $fq2
