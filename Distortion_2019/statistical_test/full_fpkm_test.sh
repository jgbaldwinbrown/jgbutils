#!/bin/bash
set -e

cat fpkm_fullchroms_described.txt | \
./convert_fpkm_to_testformat.py all_info_plus1kg.txt gc_sorted.txt  chrom_conversion.txt | \
tee temp.txt | \
./gccor_perchrom.py -c 4 -s 6 -g 5 -v 2 -H | \
tee fpkm_formatted.txt | \
pigz -p 7 \
> fpkm_formatted.txt.gz

./normal_nor_cov_gccor_perchrom.R -o fpkm_out1.txt -O fpkm_out2.txt -p fpkm_plot1.txt -P fpkm_plot2.txt fpkm_formatted.txt.gz
