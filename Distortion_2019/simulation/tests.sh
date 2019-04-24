#!/bin/bash

parallel -j 7 {} << EOF
Rscript sliding_window_sim_2rand.R -g 16000 -t 8000 -d 0.05 -w 10000 -s 1000 -o window_2rand.txt -p window_2rand.pdf -e 5
Rscript sliding_window_sim.R -g 16000 -t 8000 -d 0.05 -w 10000 -s 1000 -o window_simple.txt -p window_simple.pdf -e 5
Rscript sliding_window_sim_2rand.R -g 16000 -t 8000 -d 0.00 -w 10000 -s 1000 -o window_empty_2rand.txt -p window_empty_2rand.pdf -e 5
Rscript sliding_window_sim.R -g 16000 -t 8000 -d 0.00 -w 10000 -s 1000 -o window_empty_simple.txt -p window_empty_simple.pdf -e 5
Rscript sliding_window_sim_2rand.R -g 80000 -t 79000 -d 0.05 -w 70000 -s 1000 -o chrom_2rand.txt -p chrom_2rand.pdf -e 5
Rscript sliding_window_sim.R -g 80000 -t 79000 -d 0.05 -w 70000 -s 1000 -o chrom_simple.txt -p chrom_simple.pdf -e 5
Rscript sliding_window_sim_2rand.R -g 80000 -t 79000 -d 0.00 -w 70000 -s 1000 -o chrom_empty_2rand.txt -p chrom_empty_2rand.pdf -e 5
Rscript sliding_window_sim.R -g 80000 -t 79000 -d 0.00 -w 70000 -s 1000 -o chrom_empty_simple.txt -p chrom_empty_simple.pdf -e 5
EOF
