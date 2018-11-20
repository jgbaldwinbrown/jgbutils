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

blast_type=blastn
#blast_type options: tblastn blastn blastp tblastx
dbdir=pero_ref
qdir=alan_rna
dbpref=peromyscus_assembly_polished_v1
qname=all_genes_to_blast_mrna.fasta
odir=alan_rna_to_ref
oname=alan_all_genes_rna_to_ref.out

mkdir -p ../outs/${odir}

${blast_type} -db ../blastdb/${dbdir}/${dbpref} -query ../queries/${qdir}/${qname} -out ../outs/${odir}/${oname} -evalue 1e-5 -outfmt 6 -num_descriptions 1 -num_alignments 1


