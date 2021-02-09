#!/bin/bash

set -e

for i in 0.01 0.02 0.04 0.08 0.16 0.32 0.64 0.128 0.256 0.512 1.024 2.048; do
    echo "Rscript full_binomdat_sim.R -r 50 -R 20 -g 2000 -t 1000 -d $i -O bias_nocov_d${i}.txt
    Rscript full_binomdat_sim_chrbias_covsignal.R -r 50 -R 20 -g 2000 -t 1000 -d 0.5 -O bias_cov_d${i}.txt"
done | \
parallel -j 7

for i in 0.01 0.02 0.04 0.08 0.16 0.32 0.64 0.128 0.256 0.512 1.024 2.048; do
echo "Rscript normal_nor_cov.R -o normal_nor_out1_cov_covdat_d${i}.txt -O normal_nor_out2_cov_covdat_d${i}.txt -p normal_nor_plot1_cov_covdat_d${i}.pdf -P normal_nor_plot2_cov_covdat_d${i}.pdf bias_cov_d${i}.txt  
    Rscript normal_nor.R -o normal_nor_out1_d${i}.txt -O normal_nor_out2_d${i}.txt -p normal_nor_plot1_d${i}.pdf -P normal_nor_plot2_d${i}.pdf bias_nocov_d${i}.txt"
done | \
parallel -j 7
