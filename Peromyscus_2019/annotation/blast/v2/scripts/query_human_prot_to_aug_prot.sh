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
dbdir=pero_aug_prot_v1
qdir=human_prot
dbpref=peromyscus_augustus_proteins_v1
qname=all_human_prot.fasta
odir=human_prot_to_aug_prot_v1
oname=all_human_prot_to_aug_prot_v1.out

mkdir -p ../outs/${odir}

${blast_type} -db ../blastdb/${dbdir}/${dbpref} -query ../queries/${qdir}/${qname} -out ../outs/${odir}/${oname} -evalue 1e-5 -outfmt 6 -num_descriptions 1 -num_alignments 1


