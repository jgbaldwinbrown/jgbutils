#!/bin/bash
set -e

bash gene_density.sh
bash repeat_density.sh
python3 plot_densities.py
