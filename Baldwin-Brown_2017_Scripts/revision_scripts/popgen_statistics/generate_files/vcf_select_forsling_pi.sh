#!/bin/bash
set -e

vcftools --vcf out2.vcf \
    --positions censlist.txt \
    --indv JBB_hb705_Lcombo \
    --min-alleles 2 --max-alleles 2 \
    --remove-indels \
    --recode \
    --chr 'ctg7180000000558|quiver|quiver|quiver' \
    --out forsling/fortony_vcf_forsling_forpi

# vcftools --vcf my.vcf
#     --positions list.txt
#     -- indv population_name
#     --maf 0.10
#     --min-alleles 2 --max-alleles 2
#     --remove-indels
#     --recode
#     --out fortony
