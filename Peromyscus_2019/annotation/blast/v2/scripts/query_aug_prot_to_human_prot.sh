#!/bin/bash
#$ -N blast
#$ -q bio,pub64,adl
#$ -pe openmp 1
#$ -R y
#$ -hold_jid blastdb
module load enthought_python
module load bwa
module load samtools
module load picard-tools/1.96
module load blast/2.2.30

blast_type=blastp
#blast_type options: tblastn blastn blastp tblastx
dbdir=human_prot_v1
qdir=aug_prot
dbpref=all_human_prot_v1
qname=augustus_annotation_run3no3_protein.fasta
odir=aug_prot_to_human_prot_v1
oname=aug_prot_to_all_human_prot_v1.out

mkdir -p ../outs/${odir}

${blast_type} -db ../blastdb/${dbdir}/${dbpref} -query ../queries/${qdir}/${qname} -out ../outs/${odir}/${oname} -evalue 1e-5 -outfmt 6 -num_descriptions 1 -num_alignments 1


