#!/bin/bash

set -e

#Rscript binom_glm.R -o binomout1.txt -O binomout2.txt -p binomplot1.pdf -P binomplot2.pdf binom_testdat.txt 
#Rscript normal_glm.R -o normalout1.txt -O normalout2.txt -p normalplot1.pdf -P normalplot2.pdf binom_testdat.txt 
Rscript normal_nor.R -o normal_nor_out1.txt -O normal_nor_out2.txt -p normal_nor_plot1.pdf -P normal_nor_plot2.pdf binom_testdat.txt  

#usage: binom_glm.R [-h] [-o TXT_OUT] [-O TXT_OUT2] [-p PDF_OUT] [-P PDF_OUT2]
#                   [-m PDF_TITLE] [-M PDF_TITLE2]
#                   input
#
#positional arguments:
#  input                 Input file.
#
#optional arguments:
#  -h, --help            show this help message and exit
#  -o TXT_OUT, --txt_out TXT_OUT
#                        Output path for lm-corrected data.
#  -O TXT_OUT2, --txt_out2 TXT_OUT2
#                        Output path for means of lm-corrected data.
#  -p PDF_OUT, --pdf_out PDF_OUT
#                        Output file for plot of lm-corrected data.
#  -P PDF_OUT2, --pdf_out2 PDF_OUT2
#                        Output file for plot of lm-corrected t-test.
#  -m PDF_TITLE, --pdf_title PDF_TITLE
#                        Title for pdf.
#  -M PDF_TITLE2, --pdf_title2 PDF_TITLE2
#                        Title for pdf.
