#!/bin/bash
set -e

cp ../*counts.txt .

gunzip -c ../../pigeon_lice_ctgs_breaks_final_baccut.review.fasta.gz | \
fachrlens_sorted \
> reflens.txt

bash gene_bp_density.sh
bash repeat_bp_density.sh
bash repeat_family_bp_density.sh
python3 plot_all_family_bp_densities.py
python3 plot_select_family_densities_bp.py
