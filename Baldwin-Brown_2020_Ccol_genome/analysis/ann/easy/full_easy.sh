#!/bin/bash
set -e

REF="${1}"
GFF="${2}"

# count up repeats in your gff file
gunzip -c "${GFF}" | \
awk '$2=="repeatmasker" && $3=="match"' | \
awk -F "\t" -v OFS="\t" '{print $1, $4, $5, $6, $9}' | \
sed 's/ID.*Name/Name/' | \
sed 's/;.*//' \
> all_repeats_small.txt

# filter counts and aggregate by supergenus
cat all_repeats_small.txt | \
sed 's/Name.*genus://' | \
sed 's/%.*$//' | \
awk '{a[$5] += $4} END{for (key in a) {printf("%d\t%s\n", a[key], key)}}' | \
sort -k 1,1n > repeat_supergenus_counts.txt

gunzip -c "${REF}" | \
fachrlens_sorted \
> reflens.txt

# get a list of all contigs from the GFF
gunzip -c "${GFF}" | grep '	contig	' > contigs.gff

# Calculate 1Mb sliding windows (100kb step) of gene density in terms of basepairs per basepair
bedops \
    --chop 1000000 \
    --stagger 100000 \
    -x <( \
        awk -vOFS="\t" '{ print $1, $4-1, $5; }' contigs.gff | sort-bed -
    ) | \
tee bedops_windows_dens.bed | \
bedmap \
    --echo \
    --bases \
    --delim '\t' \
    - \
    <( \
        gunzip -c "${GFF}" | \
        awk -F "\t" -vOFS="\t" '$3=="gene"' | \
        awk -vOFS="\t" '{ print $1, $4-1, $5; }' | \
        tee genebed_dens.bed
    ) \
> answer_dens.bed

# Calculate the density (in basepairs per basepair) of repeats
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
        gunzip -c "${GFF}" | \
        awk -F "\t" -vOFS="\t" '$3=="match" && $2=="repeatmasker"' | \
        awk -vOFS="\t" '{ print $1, $4-1, $5; }' | \
        tee repbed_dens.bed
    ) \
> repanswer_dens.bed

# Calculate the density (in basepairs per basepair) of each repeat family individually
mkdir -p family_densities && \
cat repeat_supergenus_counts.txt | \
awk -F "\t" '{print $2}' | while read i ; do
    echo $i
    bedops \
        --chop 1000000 \
        --stagger 100000 \
        -x <( \
            awk -vOFS="\t" '{ print $1, $4-1, $5; }' contigs.gff | sort-bed -
        ) | \
    tee "family_densities/rep_bedops_windows_family_${i}_dens.bed" | \
    bedmap \
        --echo \
        --bases \
        --delim '\t' \
        - \
        <( \
            gunzip -c "${GFF}" | \
            awk -F "\t" -vOFS="\t" '$3=="match" && $2=="repeatmasker"' | \
            grep -E "genus:${i}(%|\s|;|\|)" | \
            awk -vOFS="\t" '{ print $1, $4-1, $5; }' | \
            tee "family_densities/repbed_family_${i}_dens.bed"
        ) \
    > "family_densities/repanswer_family_${i}_dens.bed"
done

python3 plot_all_family_bp_densities.py
python3 plot_select_family_densities_bp_pretty_3.py

