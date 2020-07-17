#!/bin/bash

set -e

Rscript binom_glm_debug.R -o binomout1.txt -O binomout2.txt -p binomplot1.pdf -P binomplot2.pdf binom_testdat.txt 
