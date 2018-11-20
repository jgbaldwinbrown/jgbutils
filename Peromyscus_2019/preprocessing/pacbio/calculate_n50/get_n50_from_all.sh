#!/bin/bash

#1192 $ cat testdat.fq | awk 'NR%4==2{print length($0)}' | tee testlengths_unsorted.txt | sort -k 1,1nr | tee testlengths_sorted.txt | python n50.py
#N50=21904; L50=21904; N50 contig count = 1

zcat /bio/jbaldwi1/all_data_from_dfs2/peromyscus_data/data/pacbio/1-18_combo/pero_combo_1-18_v2.fastq.gz | awk 'NR%4==2{print length($0)}' | tee allreads_lengths_unsorted.txt | sort -k 1,1nr | tee allreads_lengths_sorted.txt | python n50.py | tee allreads_n50.txt
