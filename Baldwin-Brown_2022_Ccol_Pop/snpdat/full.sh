#!/bin/bash
set -e

bash combine.sh

wget https://github.com/jgbaldwinbrown/c_columbae_genome/raw/main/louse_genome_0.1.1.fasta

bash gff2gtf.sh

snpdat \
	-i <(pigz -p 8 -c -d allsnps.vcf.gz) \
	-g louse_annotation_0.1.1.gtf \
	-f louse_genome_0.1.1.fasta \
	-s snpdat_summary.txt \
	-o snpdat_out.txt \
> snpdat_stdout.txt 2>&1
