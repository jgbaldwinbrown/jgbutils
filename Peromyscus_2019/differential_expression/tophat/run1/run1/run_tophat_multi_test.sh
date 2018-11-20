#!/bin/bash
#$ -N tophat_mu
#$ -q bio,pub64
#$ -pe openmp 32-64
#$ -R y
#$ -t 1-31
#$ -ckpt restart
##$ -hold_jid blastdb

module load bowtie2/2.2.3
module load tophat/2.1.0

jobnum=$SGE_TASK_ID
jobnum=1

inlist=inlist.txt
inline=`head -n $jobnum $inlist | tail -n 1 | tr -d '\n'`
in1=`echo $inline | cut -d ' ' -f 1 | tr -d '\n'`
outpre=`echo $in1 | rev | cut -d '/' -f 1 | rev | cut -d '.' -f 1 | tr -d '\n'`
ref=peromyscus_assembly_polished_v1

echo $inlist
echo $inline
echo $in1
echo $outpre
echo $ref

#tophat --coverage-search -o tophat_out_${outpre} $ref $inline
