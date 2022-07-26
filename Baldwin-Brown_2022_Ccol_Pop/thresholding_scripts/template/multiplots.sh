#!/bin/bash
set -e

combine_fst_and_pfsts \
	all_bigfile_fsts.txt \
	all_bigfile_pfsts.txt \
> all_bigfile_combo.txt

cat all_bigfile_combo.txt | make_all_multiplots
