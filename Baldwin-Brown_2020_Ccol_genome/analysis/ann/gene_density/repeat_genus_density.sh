#!/bin/bash
set -e

mkdir -p genus_densities && \
cat repeat_genus_counts.txt | \
awk -F "\t" '{print $2}' | while read i ; do
    echo $i
    bedops \
        --chop 1000000 \
        --stagger 100000 \
        -x <( \
            awk -vOFS="\t" '{ print $1, $4-1, $5; }' contigs.gff | sort-bed -
        ) | \
    tee "genus_densities/rep_bedops_windows_family_${i}.bed" | \
    bedmap \
        --echo \
        --count \
        --delim '\t' \
        - \
        <( \
            gunzip -c ../../louseref.all.sprot.interproscan_tsv.clean.sorted.baccut.gff.gz | \
            awk -F "\t" -vOFS="\t" '$3=="match" && $2=="repeatmasker"' | \
            grep -E "genus:${i}(\s|$|;|\|)" | \
            awk -vOFS="\t" '{ print $1, $4-1, $5; }' | \
            tee "genus_densities/repbed_family_${i}.bed"
        ) \
    > "genus_densities/repanswer_family_${i}.bed"
done
