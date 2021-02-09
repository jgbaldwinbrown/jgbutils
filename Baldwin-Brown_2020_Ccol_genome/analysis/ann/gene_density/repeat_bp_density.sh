#!/bin/bash
set -e

bedops \
    --chop 1000000 \
    --stagger 100000 \
    -x <( \
        awk -vOFS="\t" '{ print $1, $4-1, $5; }' contigs.gff | sort-bed -
    ) | \
tee rep_bedops_windows_dens.bed | \
bedmap \
    --echo \
    --bases \
    --delim '\t' \
    - \
    <( \
        gunzip -c ../../louseref.all.sprot.interproscan_tsv.clean.sorted.baccut.gff.gz | \
        awk -F "\t" -vOFS="\t" '$3=="match" && $2=="repeatmasker"' | \
        awk -vOFS="\t" '{ print $1, $4-1, $5; }' | \
        tee repbed_dens.bed
    ) \
> repanswer_dens.bed

# bedops --chop 500000 --stagger 100000 -x <(awk -vOFS="\t" '{ print $1, $2-1, $2; }' scaffolds.txt | sort-bed -) | bedmap --echo --count --delim '\t' - <(vcf2bed < snps.vcf) > answer.bed
