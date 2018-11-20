#!/bin/bash
#$ -N featurecount_mu
#$ -q bio,pub64,adl
#$ -pe openmp 1
#$ -R y
#$ -t 1-31
#$ -ckpt restart
###$ -hold_jid blastdb

module load bowtie2/2.2.3
module load tophat/2.1.0

export PATH=/bio/jbaldwi1/all_data_from_dfs2/shrimp_data/tophat/run1/subread/subread-1.5.0-p1-Linux-x86_64/bin:$PATH

inlist=../../run1/inlist.txt
inline=`head -n $jobnum | tail -n 1 | tr -d '\n'`
in1=`echo $inline | cut -d ' ' -f 1 | tr -d '\n'`
topoutpre=`echo $in1 | rev | cut -d '/' -f 1 | rev | cut -d '.' -f 1 | tr -d '\n'`
myinfile=../../run1/tophat_out_${topoutpre}
ref=MYREF
gtf=MYGTF

featureCounts -p -t exon -g gene_id -a ${gtf} -o counts_${topoutpre}.txt ${myinfile}/accepted_hits.bam

