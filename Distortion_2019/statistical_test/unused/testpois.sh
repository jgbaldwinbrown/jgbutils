#!/bin/bash

set -e

Rscript pois_glm.R -o poisout1.txt -O poisout2.txt -p poisplot1.pdf -P poisplot2.pdf binom_testdat.txt 
