#!/bin/bash

set -e

#for i in 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20; do
#    echo "Rscript full_binomdat_sim.R -r 50 -R 20 -g 2000 -t 1000 -d $i -O bias_nocov_trial2_d${i}.txt"
#done | \
#parallel -j 7
#
for i in 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20; do
echo "Rscript normal_nor_full.R -o normal_nor_out1_trial3_d${i}.txt -O normal_nor_out2_trial3_d${i}.txt -p normal_nor_plot1_trial3_d${i}.pdf -P normal_nor_plot2_trial3_d${i}.pdf bias_nocov_trial2_d${i}.txt"
done | \
parallel -j 7
