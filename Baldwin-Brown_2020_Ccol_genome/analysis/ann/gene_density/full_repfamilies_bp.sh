#!/bin/bash
set -e

# bash gene_density.sh
# bash repeat_density.sh
bash repeat_family_bp_density.sh
python3 plot_all_family_bp_densities.py
python3 plot_select_family_bp_densities.py
