#!/bin/bash
set -e


gunzip -c ../louseref.all.sprot.interproscan_tsv.clean.sorted.baccut.gff.gz | \
mawk '$2=="repeatmasker" && $3=="match"' | \
mawk -F "\t" -v OFS="\t" '{print $1, $4, $5, $6, $9}' | \
sed 's/ID.*Name/Name/' | \
sed 's/;.*//' | \
tee all_repeats_small.txt | \
mawk '{print $3-$2}' | \
datamash sum 1 > repeat_bp.txt

gunzip -c ../pigeon_lice_ctgs_breaks_final_baccut.review.fasta.gz | \
grep -v '^>' | \
tr -d '\n' | \
wc -c \
> total_bp.txt

# calculate proportion of repeat species:

cat all_repeats_small.txt | \
sed 's/[|_-][^	]*$//' | \
awk '{a[$5] += $4} END{for (key in a) {printf("%d\t%s\n", a[key], key)}}' | \
sort -k 1,1n > repeat_type_counts.txt

TOTBP=`cat total_bp.txt | tr -d '\n'`
TOTREP=`cat repeat_type_counts.txt | datamash sum 1 | tr -d '\n'`

cat repeat_type_counts.txt | \
awkf -v totbp="$TOTBP" -v totrep="$TOTREP" '{print($1, $1/totbp, $1/totrep, $2)}' \
> repeat_type_props.txt

# calculate proportion of repeat genuses:

cat all_repeats_small.txt | \
sed 's/Name.*genus://' | \
awk '{a[$5] += $4} END{for (key in a) {printf("%d\t%s\n", a[key], key)}}' | \
sort -k 1,1n > repeat_genus_counts.txt

TOTBP=`cat total_bp.txt | tr -d '\n'`
TOTREP=`cat repeat_genus_counts.txt | datamash sum 1 | tr -d '\n'`

cat repeat_genus_counts.txt | \
awkf -v totbp="$TOTBP" -v totrep="$TOTREP" '{print($1, $1/totbp, $1/totrep, $2)}' \
> repeat_genus_props.txt

# calculate proportion of repeat supergenuses

cat all_repeats_small.txt | \
sed 's/Name.*genus://' | \
sed 's/%.*$//' | \
awk '{a[$5] += $4} END{for (key in a) {printf("%d\t%s\n", a[key], key)}}' | \
sort -k 1,1n > repeat_supergenus_counts.txt

TOTBP=`cat total_bp.txt | tr -d '\n'`
TOTREP=`cat repeat_supergenus_counts.txt | datamash sum 1 | tr -d '\n'`

cat repeat_supergenus_counts.txt | \
awkf -v totbp="$TOTBP" -v totrep="$TOTREP" '{print($1, $1/totbp, $1/totrep, $2)}' \
> repeat_supergenus_props.txt
