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

refname=peromyscus_assembly_polished_v1.fasta
dbpref=peromyscus_assembly_polished_v1
refdir=pero_ref
dbdir=pero_ref
dbtype=nucl
#dbtype options: nucl prot 

mkdir -p ../blastdb/${dbdir}

makeblastdb -in ../ref/${refdir}/${refname} -dbtype ${dbtype} -parse_seqids -out ../blastdb/${dbdir}/${dbpref}
