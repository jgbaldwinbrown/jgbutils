#!/bin/bash

set -e

Rscript pois_glm_err4.R -o poiserr4out1.txt -O poiserr4out2.txt -p poiserr4plot1.pdf -P poiserr4plot2.pdf binom_testdat.txt 
