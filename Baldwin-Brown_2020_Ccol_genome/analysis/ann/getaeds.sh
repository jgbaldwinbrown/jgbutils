#!/bin/bash
set -e

echo -e "contig\tsequence_type\taed\teaed\tqi" > aeds_prot.txt

gunzip -c ../louseref_untwelve.all.maker.baccut.proteins.fasta.gz | \
grep ">" | sed 's/^>//' | tr ' ' '\t' | \
sed 's/\(e\?AED\|QI\)://g' \
>> aeds_prot.txt
