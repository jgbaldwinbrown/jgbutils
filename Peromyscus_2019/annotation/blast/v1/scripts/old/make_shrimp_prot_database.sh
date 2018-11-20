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

makeblastdb -in /bio/jbaldwi1/all_data_from_dfs2/shrimp_data/blast_alignments/final_assembly_version_9-30-15/augustus_comparisons/augustus_prot/shrimp_augustus_all_10-12-15_protseq.fasta -dbtype prot -parse_seqids -out ../blastdb/shrimp_prot_blastdb/shrimp_prot_blastdb
