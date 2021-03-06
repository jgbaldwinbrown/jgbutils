#!/bin/bash
#$ -N blastdb
#$ -q bio,pub64,adl
#$ -pe openmp 1
#$ -R y
module load enthought_python
module load bwa
module load samtools
module load picard-tools/1.96
module load blast/2.2.30

#pero_aug_v1/augustus_proteins_v1.fasta

refname=human_prot_minimal.fasta
dbpref=human_prot_minimal_v1
refdir=human_prot
dbdir=human_prot_v1
dbtype=prot
#dbtype options: nucl prot 

mkdir -p ../blastdb/${dbdir}

makeblastdb -in ../ref/${refdir}/${refname} -dbtype ${dbtype} -parse_seqids -out ../blastdb/${dbdir}/${dbpref}
