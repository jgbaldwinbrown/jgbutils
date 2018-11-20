#!/bin/bash
#$ -N INDEXER
#$ -q bio,pub64,adl
#$ -pe openmp 2
#$ -R y
#$ -hold_jid copy
module load enthought_python
module load bwa
module load samtools
module load picard-tools/1.96
bwa index ref/peromyscus_assembly_polished_v1.fasta
samtools faidx ref/peromyscus_assembly_polished_v1.fasta
java -jar /data/apps/picard-tools/1.96/CreateSequenceDictionary.jar R=ref/peromyscus_assembly_polished_v1.fasta O=ref/peromyscus_assembly_polished_v1.dict
