#!/bin/bash
#$ -N SNPT
#$ -q bio,pub64,adl
#$ -pe openmp 1
#$ -R y
#$ -hold_jid MAKEVCF
module load enthought_python
module load java/1.7
module load bwa
module load samtools
module load picard-tools/1.96
module load gatk/3.1-1
module load perl/5.16.2

##add paths to files
MAINPATH=data/raw/
REFPATH=ref/peromyscus_assembly_polished_v1.fasta
BWATEMPPATH=data/bwa_temp/

##add array of filenames

PREFIXES=(JBB_hb701_Lcombo
JBB_hb702_Lcombo
JBB_hb703_Lcombo
JBB_hb704_Lcombo
JBB_hb705_Lcombo
JBB_hb706_Lcombo
JBB_hb707_Lcombo
JBB_hb708_Lcombo
JBB_hb709_Lcombo
JBB_hb710_Lcombo
JBB_hb711_Lcombo
JBB_hb712_Lcombo)
PREFIX=shrimp_inbred_ill2

perl snptable_8sigfig.pl 12 7 <data/gatk/only-PASS-Q30-SNPs.vcf >data/snp_tables/only-PASS-Q30-SNPs.txt
perl snptable_8sigfig.pl 12 7 <data/gatk/only-PASS-Q30-INDEL.vcf >data/snp_tables/only-PASS-Q30-INDEL.txt

#perl SNPtable.pl 7 4 <only-PASS-Q30-SNPs.vcf >only-PASS-Q30-SNPs.txt
#perl SNPtable.pl 7 4 <only-PASS-Q30-INDEL.vcf >only-PASS-Q30-INDEL.txt
