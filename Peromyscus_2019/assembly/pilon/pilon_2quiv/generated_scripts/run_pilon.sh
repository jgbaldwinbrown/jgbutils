#!/bin/bash
#$ -N pilon_1
#$ -pe openmp 64
#$ -R y
#$ -q bio
#$ -ckpt restart
#$ -hold_jid bwa_pilon_1

cd $SGE_O_WORKDIR

module load jje/jjeutils/0.1a
module load jje/pilon/1.16

module load samtools/1.3
module load perl
module load bwa/0.7.8

java -Xmx450g -jar /data/apps/user_contributed_software/jje/pilon/1.16/pilon-1.16.jar \
      --genome infasta.fasta \
      --frags pero.bwape.sorted.bam && \
rm -r *.bam* && rm -r *.sam*

