#!/bin/bash
set -e

# bash combine.sh
# 
# cp /home/jgbaldwinbrown/Documents/git_repositories/louse_genome/louse_genome_0.1.1.fasta ./
# 
# bash gff2gtf.sh

snpdat \
	-i <(pigz -p 8 -c -d allsnps.vcf.gz) \
	-g louse_annotation_0.1.1.gtf \
	-f louse_genome_0.1.1.fasta \
	-s snpdat_summary.txt \
	-o snpdat_out.txt \
> snpdat_stdout.txt 2>&1
