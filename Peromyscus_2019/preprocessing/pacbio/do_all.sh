#!/bin/bash
#find . -name '*.gz' -exec basename {} 01.1-Reads.fastq.gz \; | while read line
cat all_fastqs_10-6-15.txt | while read line
do
zcat ${line} | python calculate_average_read_quality.py > ${line}.qualities
done

#zcat ./data/reads_for_paper/template_conc/R056-A01.1-Reads.fastq.gz | 
#zcat ./data/reads_for_paper/template_conc/R056-B01.1-Reads.fastq.gz
#zcat ./data/reads_for_paper/template_conc/R057-C01.1-Reads.fastq.gz
#zcat ./data/reads_for_paper/poly_exp/R043-F01.1-Reads.fastq.gz
#zcat ./data/reads_for_paper/poly_exp/R042-A01.1-Reads.fastq.gz
#zcat ./data/reads_for_paper/poly_exp/R043-E01.1-Reads.fastq.gz
#zcat ./data/reads_for_paper/poly_exp/R043-C01.1-Reads.fastq.gz
