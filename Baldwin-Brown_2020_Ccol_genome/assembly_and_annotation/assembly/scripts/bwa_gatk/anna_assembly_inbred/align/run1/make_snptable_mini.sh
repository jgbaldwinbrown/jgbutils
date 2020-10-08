#!/bin/bash
#$ -N SNPT
#$ -q bio,pub64,adl
#$ -pe openmp 1
#$ -R y
#$ -hold_jid MAKEVCF
#module load enthought_python
#module load java/1.7
#module load bwa
#module load samtools
#module load picard-tools/1.96
#module load gatk/3.1-1
#module load perl/5.16.2

##add paths to files
HOMEPATH=temp/bwa_gatk/anna_assembly_inbred/align/run1/
MAINPATH=data/raw/
REFPATH=${HOMEPATH}/ref/ALM_F2Male_MDS349_CLCassembly.fasta
BWATEMPPATH=data/bwa_temp/

picardpath=/data1/jbrown/local_programs/picard/picard.jar
gatkpath=/data1/jbrown/local_programs/gatk/GenomeAnalysisTK.jar

perl scripts/bwa_gatk/anna_assembly_inbred/align/run1/snptable_8sigfig.pl 1 1 <${HOMEPATH}/data/gatk/only-PASS-Q30-SNPs-mini.vcf >${HOMEPATH}/data/snp_tables/only-PASS-Q30-SNPs-mini.txt

#perl SNPtable.pl 7 4 <only-PASS-Q30-SNPs.vcf >only-PASS-Q30-SNPs.txt
#perl SNPtable.pl 7 4 <only-PASS-Q30-INDEL.vcf >only-PASS-Q30-INDEL.txt
