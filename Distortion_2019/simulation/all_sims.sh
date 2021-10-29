#!/bin/bash

set -e



parallel -j 8 {} << EOF
Rscript full_binomdat_sim_chrbias_covsignal.R -r 50 -R 20 -g 2000 -t 1000 -d 0.5 -O bias_cov.txt
Rscript full_binomdat_sim_chrbias.R -r 50 -R 20 -g 2000 -t 1000 -d 0.2 -O bias.txt
Rscript full_binomdat_sim.R -r 50 -R 20 -g 2000 -t 1000 -d 0.2
Rscript sliding_window_sim_2rand.R -g 16000 -t 8000 -d 0.05 -w 10000 -s 1000 -o window_2rand.txt -p window_2rand.pdf -e 5
Rscript sliding_window_sim.R -g 16000 -t 8000 -d 0.05 -w 10000 -s 1000 -o window_simple.txt -p window_simple.pdf -e 5
Rscript sliding_window_sim_2rand.R -g 16000 -t 8000 -d 0.00 -w 10000 -s 1000 -o window_empty_2rand.txt -p window_empty_2rand.pdf -e 5
Rscript sliding_window_sim.R -g 16000 -t 8000 -d 0.00 -w 10000 -s 1000 -o window_empty_simple.txt -p window_empty_simple.pdf -e 5
Rscript sliding_window_sim_2rand.R -g 80000 -t 79000 -d 0.05 -w 70000 -s 1000 -o chrom_2rand.txt -p chrom_2rand.pdf -e 5
Rscript sliding_window_sim.R -g 80000 -t 79000 -d 0.05 -w 70000 -s 1000 -o chrom_simple.txt -p chrom_simple.pdf -e 5
Rscript sliding_window_sim_2rand.R -g 80000 -t 79000 -d 0.00 -w 70000 -s 1000 -o chrom_empty_2rand.txt -p chrom_empty_2rand.pdf -e 5
Rscript sliding_window_sim.R -g 80000 -t 79000 -d 0.00 -w 70000 -s 1000 -o chrom_empty_simple.txt -p chrom_empty_simple.pdf -e 5
EOF
