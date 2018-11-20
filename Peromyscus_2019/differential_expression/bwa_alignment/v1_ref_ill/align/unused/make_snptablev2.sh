#!/bin/bash
#$ -N SNPT2
#$ -q bio
#$ -pe openmp 1
#$ -R y
##$ -hold_jid PREPVCFD
module load enthought_python
module load java/1.7
module load bwa
module load samtools
module load picard-tools/1.96
module load gatk/3.1-1
module load perl/5.16.2

##add paths to files
MAINPATH=/dfs1/bio/jbaldwi1/shrimp_data/illumina_data_3_wild_and_rna/bwa_alignment/v1_nondbg2olc_downsampled/data/raw/
REFPATH=/dfs1/bio/jbaldwi1/shrimp_data/illumina_data_3_wild_and_rna/bwa_alignment/v1_nondbg2olc_downsampled/ref/shrimp_reference.fa

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

perl snptablev2.pl 12 7 <data/gatk/only-PASS-Q30-SNPs.vcf >data/snp_tables/v2/only-PASS-Q30-SNPs-cov.txt
perl snptablev2.pl 12 7 <data/gatk/only-PASS-Q30-INDEL.vcf >data/snp_tables/v2/only-PASS-Q30-INDEL-cov.txt

#perl SNPtable.pl 7 4 <only-PASS-Q30-SNPs.vcf >only-PASS-Q30-SNPs.txt
#perl SNPtable.pl 7 4 <only-PASS-Q30-INDEL.vcf >only-PASS-Q30-INDEL.txt
