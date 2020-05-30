#!/bin/bash
set -e

module add R/3.6.2  	

cat fortony_vcf_forsling.recode.vcf | \
grep -v "^#" | \
cut -f 10 | \
cut -d ':' -f 2 | \
sed '/^\./d' | \
tr "," "\t" | \
awk -F'\t' 'NF==2 {print}' | \
perl countem.pl >countem.txt

Rscript calc_theta.R

### pi:

cat fortony_vcf_forsling_forpi.recode.vcf  | \
grep -v "^#" | \
cut -f 10 | \
cut -d ':' -f 2 | \
sed '/^\./d' | \
tr "," "\t" | \
awk -F'\t' 'NF==2 {print}' > raw.count.txt

Rscript calc_pi.R
