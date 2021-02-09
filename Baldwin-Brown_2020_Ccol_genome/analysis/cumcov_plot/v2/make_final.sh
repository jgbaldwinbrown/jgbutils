#!/bin/bash
set -e

gunzip -c ../../pigeon_lice_ctgs_breaks_final_baccut.review.fasta.gz | \
grep ">" | \
wc -l \
> temp/hic_scaffold_baccut/hic_scaf_count.txt

gunzip -c ../../pigeon_lice_ctgs_breaks_final_baccut.review.fasta.gz | \
fa2tab | \
tab2fa | \
grep -v '>' | \
awk '{print length($1)}' \
> temp/hic_scaffold_baccut/hic_scaf_lengths.txt

mkdir -p temp/hic_scaffold_baccut_final

Rscript \
    cumcov_plot_multiple_v4_final.R \
    temp/hic_scaffold_baccut/hic_scaf_lengths.txt \
    temp/canu/v2/canu_v2_lengths.txt \
    "Cumulative  coverage  of  various  assemblies" \
    temp/hic_scaffold_baccut_final/hic_scaf_multiplot_final.pdf

