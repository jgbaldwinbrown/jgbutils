#!/bin/bash

set -e

mkdir -p temp/population_sequencing/bwa/bwa_all/1_mito
rsync -avP /data1/jbrown/louse_project/raw_data/mito_ref/Cocol_mt_contigsUnpaired.fasta temp/population_sequencing/bwa/bwa_all/1_mito/mito.fasta
bwa index temp/population_sequencing/bwa/bwa_all/1_mito/mito.fasta
find raw_data/population_sequencing/1/15515R/Fastq -name '*.fastq.gz' | \
sort | \
paste - - | \
while read i
do
    a=`echo $i | cut -d ' ' -f 1`
    b=`echo $i | cut -d ' ' -f 2`
    out=temp/population_sequencing/bwa/bwa_all/1_mito/`basename $a _R1_001.fastq.gz`.bam
    bwa mem -t 32 temp/population_sequencing/bwa/bwa_all/1_mito/mito.fasta <(gunzip -c $a) <(gunzip -c $b) | samtools view -S -b | samtools sort -T prefix -O 'bam' > $out
    #echo $i $a $b $out
done
