#!/bin/bash
#$ -N trimmomatic
#$ -q bio,abio,free64,pub64
#$ -pe openmp 1-16
#$ -t 1-21
#$ -ckpt restart
#$ -hold_jid prinseq

jobnum=$SGE_TASK_ID

module load trimmomatic

freadi=`echo "${jobnum} * 2 - 1" | bc | tr -d '\n'`
rreadi=`echo "${jobnum} * 2" | bc | tr -d '\n'`
fread=`head -n $freadi rnaseq_paths_sorted.txt | tail -n 1`
rread=`head -n $rreadi rnaseq_paths_sorted.txt | tail -n 1`

freadop=`echo $(basename $fread .fastq.gz)_paired.fq.gz`
freados=`echo $(basename $fread .fastq.gz)_unpaired.fq.gz`
rreadop=`echo $(basename $rread .fastq.gz)_paired.fq.gz`
rreados=`echo $(basename $rread .fastq.gz)_unpaired.fq.gz`

java -jar /data/apps/trimmomatic/0.35/trimmomatic-0.35.jar PE -threads $CORES -phred33 $fread $rread $freadop $freados $rreadop $rreados CROP:97 HEADCROP:15 ILLUMINACLIP:TruSeq3-PE.fa:2:30:10
