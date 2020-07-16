#!/bin/bash
set -e

cat fpkm_fullchroms_described.txt | \
./convert_fpkm_to_testformat.py all_info_plus1kg.txt gc_sorted.txt  chrom_conversion.txt | \
tee temp.txt | \
./gccor_perchrom.py -c 1 -s 0 -g 3 -v 4 -H > fpkm_formatted.txt

./normal_nor_cov_gccor_perchrom.R -o fpkm_out1.txt -O fpkm_out2.txt -p fpkm_plot1.txt -P fpkm_plot2.txt fpkm_formatted.txt
