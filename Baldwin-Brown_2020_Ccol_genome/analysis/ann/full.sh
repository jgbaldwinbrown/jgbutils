#!/bin/bash
set -e

bash aed_calcs.sh
bash count_for_paper.sh
bash count_repeats.sh
bash getaeds.sh
python3 plot_aeds4_final.py
