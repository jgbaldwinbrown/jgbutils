#!/bin/bash
set -e

gunzip -c snpdat_out.txt.gz | \
cut -d '	' -f 1,2,3,4,6,19,22 | \
mawk -F "\t" -v OFS="\t" '$3 != "NA"' | \
gzip -c > snpdat_out_small2.txt.gz
