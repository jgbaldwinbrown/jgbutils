#!/bin/bash

set -e

Rscript pois_glm_err2.R -o poiserr2out1.txt -O poiserr2out2.txt -p poiserr2plot1.pdf -P poiserr2plot2.pdf binom_testdat.txt 
