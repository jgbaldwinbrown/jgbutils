#!/bin/bash
set -e

combine_pfst_fst_selec \
	all_bigfile_fsts.txt \
	all_bigfile_pfsts.txt \
	old_selecs_1k_paths.txt \
> pfst_fst_selec_combo.txt
