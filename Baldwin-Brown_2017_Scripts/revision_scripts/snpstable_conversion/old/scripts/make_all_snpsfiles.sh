#!/bin/bash
cat only-PASS-Q30-SNPs-cov.txt | python make_snpsfile.py > snpsfiles_v2/snpsfile_12pop.txt
#cat only-PASS-Q30-SNPs-cov-11pop.txt | python make_snpsfile.py > snpsfiles_v2/snpsfile_11pop.txt
#cat only-PASS-Q30-INDEL-cov-11pop.txt | python make_snpsfile.py > snpsfiles_v2/snpsfile_11pop_indel.txt
#cat only-PASS-Q30-SNPs-cov-11pop-deg4s.txt | python make_snpsfile.py > snpsfiles_v2/snpsfile_11pop_degs.txt
#cat only-PASS-Q30-INDEL-cov.txt | python make_snpsfile.py > snpsfiles_v2/snpsfile_12pop_indel.txt
#cat only-PASS-Q30-SNPs-cov-deg4s.txt | python make_snpsfile.py > snpsfiles_v2/snpsfile_12pop_degs.txt
