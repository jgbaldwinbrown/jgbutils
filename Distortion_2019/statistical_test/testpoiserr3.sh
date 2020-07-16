#!/bin/bash

set -e

Rscript pois_glm_err3.R -o poiserr3out1.txt -O poiserr3out3.txt -p poiserr3plot1.pdf -P poiserr3plot3.pdf binom_testdat.txt 
