#!/bin/bash
set -e

bedtools genomecov -d -split -ibam forsling/JBB_hb705_unmerged_realigned_deduped2_forsling.bam | \
grep -F 'ctg7180000000558|quiver|quiver|quiver' | \
cut -f3 | \
sort | \
uniq -c \
> forsling/JBB_hb705_forsling_covs_1chr_correct.txt

# bedtools genomecov -d -split -ibam Chr??_population??.bam | cut -f3 | sort | uniq -c
