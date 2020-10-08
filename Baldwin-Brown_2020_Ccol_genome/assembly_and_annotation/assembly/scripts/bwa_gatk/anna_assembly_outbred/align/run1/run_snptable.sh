#!/bin/bash
#$ -N makesnptable
#$ -q bio,pub64,adl
#$ -ckpt restart
#$ -hold_jid MAKEVCF

perl snptable_8sigfig.pl 12 7 <data/gatk/only-PASS-Q30-SNPs_v2.vcf >data/snp_tables/only-PASS-Q30-SNPs-cov_v2_8sigfig.txt
perl snptable_8sigfig.pl 12 7 <data/gatk/only-PASS-Q30-INDEL_v2.vcf >data/snp_tables/only-PASS-Q30-INDEL-cov_v2_8sigfig.txt
