#!/bin/bash
#$ -N fq_screen
#$ -q bio,abio,pub64,free64,adl,pub8i
#$ -ckpt restart
#$ -hold_jid trimmomatic
#$ -pe openmp 8
#$ -t 1-21

module load bwa
export PATH=/bio/jbaldwi1/programs/fastq_screen/fastq_screen_v0.9.0:$PATH

jobnum=$SGE_TASK_ID
rindex2=`echo "$jobnum * 2" | bc | tr -d '\n'`
rindex1=`echo "$rindex2 - 1" | bc | tr -d '\n'`
fq1=`head -n $rindex1 all_rnaseq_reads.txt | tail -n 1`
fq2=`head -n $rindex2 all_rnaseq_reads.txt | tail -n 1`

mkdir -p fastqscreened
mkdir -p fastqscreened_keepbor

fastq_screen --aligner bwa --subset 0 --nohits --outdir fastqscreened --threads $CORES --conf fqs_conf.txt $fq1 $fq2

fastq_screen --aligner bwa --subset 0 --filter 3 --tag --outdir fastqscreened_keepbor --threads $CORES --conf fqs_conf.txt $fq1 $fq2
