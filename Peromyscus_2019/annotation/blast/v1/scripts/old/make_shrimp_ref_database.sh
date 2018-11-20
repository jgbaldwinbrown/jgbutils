#!/bin/bash
#$ -N blastdb
#$ -q bio,pub64
#$ -pe openmp 1
#$ -R y
module load enthought_python
module load bwa
module load samtools
module load picard-tools/1.96
module load blast/2.2.30

makeblastdb -in ../ref/shrimp_qmerged.quiver.fasta -dbtype nucl -parse_seqids -out ../blastdb/shrimp_ref_blastdb/shrimp_ref_v2_nucl_db
