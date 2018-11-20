#!/bin/bash
#$ -N INDEXER
#$ -q bio
#$ -pe openmp 2
#$ -R y
module load enthought_python
module load bwa
module load samtools
module load picard-tools/1.96
bwa index ref/shrimp_reference.fa
samtools faidx ref/shrimp_reference.fa
java -jar /data/apps/picard-tools/1.96/CreateSequenceDictionary.jar R=ref/shrimp_reference.fa O=ref/shrimp_reference.dict
