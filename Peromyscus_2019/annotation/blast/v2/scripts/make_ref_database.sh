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

refname=REFNAME
dbpref=DBPREF
refdir=REFDIR
dbdir=DBDIR
dbtype=DBTYPE
#dbtype options: nucl prot 

mkdir -p ../blastdb/${dbdir}

makeblastdb -in ../ref/${refdir}/${refname} -dbtype ${dbtype} -parse_seqids -out ../blastdb/${dbdir}/${dbpref}
