#!/bin/bash
set -e

gunzip -c ../../louseref.all.sprot.interproscan_tsv.clean.sorted.baccut.gff.gz | \
awk '$3=="gene"' | \
grep -f <(cat important_go_terms.txt | \
    sed 's/.*	//') | \
grep -o 'GO:[0-9]*' | \
sort | \
uniq -c | \
grep -f <(cat important_go_terms.txt | \
    sed 's/.*	//') \
> go_counts.txt
