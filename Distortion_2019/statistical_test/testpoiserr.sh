#!/bin/bash

set -e

Rscript pois_glm_err.R -o poiserrout1.txt -O poiserrout2.txt -p poiserrplot1.pdf -P poiserrplot2.pdf binom_testdat.txt 
