#!/bin/bash

set -e

Rscript full_binomdat_sim.R -r 50 -R 20 -g 2000 -t 1000 -d 0.2

#usage: full_binomdat_sim.R [-h] [-e RSEED] [-r REPS] [-R SPERM_REPS]
#                           [-g GENSIZE] [-t TREATSIZE] [-c CHROMS]
#                           [-b BPS_PER_HETSNP] [-d DISTORTION_FRAC]
#                           [-a AVERAGE_COVERAGE] [-O SIMULATION_DATA_OUT]
#                           [-o TXT_OUT] [-p PDF_OUT] [-m PDF_TITLE]
#
#optional arguments:
#  -h, --help            show this help message and exit
#  -e RSEED, --rseed RSEED
#                        random number generator seed (default=0).
#  -r REPS, --reps REPS  Number of replicate control individuals (default=20).
#  -R SPERM_REPS, --sperm_reps SPERM_REPS
#                        Number of replicate sperm samples (default=20).
#  -g GENSIZE, --gensize GENSIZE
#                        Number of heterozygous SNPs in the genome
#                        (default=2000).
#  -t TREATSIZE, --treatsize TREATSIZE
#                        Number of heterozygous SNPs in the distorted region
#                        (default=1000).
#  -c CHROMS, --chroms CHROMS
#                        Number of chromosomes per genome(default=4).
#  -b BPS_PER_HETSNP, --bps_per_hetsnp BPS_PER_HETSNP
#                        Basepairs per heterozygous SNP (default=2000).
#  -d DISTORTION_FRAC, --distortion_frac DISTORTION_FRAC
#                        Degree of distortion as a fraction of allele
#                        frequency(default=0.1).
#  -a AVERAGE_COVERAGE, --average_coverage AVERAGE_COVERAGE
#                        Average genome coverage (default=1.75).
#  -O SIMULATION_DATA_OUT, --simulation_data_out SIMULATION_DATA_OUT
#                        Path to simulation data output file
#                        (default=out_sim.txt).
#  -o TXT_OUT, --txt_out TXT_OUT
#                        Path to text output file (default=out.txt).
#  -p PDF_OUT, --pdf_out PDF_OUT
#                        Path to pdf output file (default=out.pdf).
#  -m PDF_TITLE, --pdf_title PDF_TITLE
#                        Title of plot.
