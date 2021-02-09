#!/bin/bash
set -e

cat fpkm_fullchroms_described.txt | ./convert_fpkm_to_testformat.py all_info_plus1kg.txt gc_sorted.txt  chrom_conversion.txt
