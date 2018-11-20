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

refname=augustus_annotation_run3no3_protein.fasta
dbpref=peromyscus_augustus_proteins_v1
refdir=pero_aug_v1
dbdir=pero_aug_prot_v1
dbtype=prot
#dbtype options: nucl prot 

mkdir -p ../blastdb/${dbdir}

makeblastdb -in ../ref/${refdir}/${refname} -dbtype ${dbtype} -parse_seqids -out ../blastdb/${dbdir}/${dbpref}
