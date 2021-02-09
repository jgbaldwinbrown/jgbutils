#!/bin/bash

set -e

Rscript full_binomdat_sim_chrbias_covsignal.R -r 50 -R 20 -g 2000 -t 1000 -d 0.5 -O bias_cov.txt
