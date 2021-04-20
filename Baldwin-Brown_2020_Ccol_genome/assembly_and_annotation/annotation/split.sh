#!/bin/bash
set -e

gunzip -c louseref_nmask_long_copy1.fasta.gz | \
python3 fasplit.py -r 10000 -c PGA_scaffold_12__111_contigs__length_12921414 -o splits
cd splits && gzip *
