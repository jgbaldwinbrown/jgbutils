#!/bin/bash

set -e



#temp/split_minion_rna_for_carnac/done.txt: temp/minion_rna_alignment/1-4_final_genome/mrna_align_sorted.bam
#	mkdir -p `dirname $@`
#	rsync -avP $< `dirname $@`
#	cd `dirname $@` && \
#		bamtools split -in `basename $@` -reference
#	touch $@
#
#temp/minion_rnaseq_carnac_split/1/minion_rna1-4_1d_combo.fa: temp/minion_rna_basecalling/1-4/minion_rna1-4_1d_combo.fq
#	mkdir -p `dirname $@`
#	fq2fa $< > $@
#
#temp/minion_rnaseq_carnac_split/1/input_CARNAC.txt: temp/minion_rnaseq_minimap2/1/ovlpfull.paf temp/minion_rnaseq_carnac/1/minion_rna1-4_1d_combo.fa
#	mkdir -p `dirname $@`
#	paf_to_CARNAC.py $< temp/minion_rnaseq_carnac/1/minion_rna1-4_1d_combo.fa $@
#
#temp/minion_rnaseq_carnac_split/1/output_CARNAC.txt: temp/minion_rnaseq_carnac/1/input_CARNAC.txt 
#	mkdir -p `dirname $@`
#	ulimit -s unlimited && CARNAC-LR -f $< -o $@
		
#temp/minion_rnaseq_carnac/1/output_CARNAC.fa.gz: scripts/carnac/carnac2fa.py temp/minion_rnaseq_carnac/1/output_CARNAC.txt temp/minion_rnaseq_carnac/1/minion_rna1-4_1d_combo.fa
#	mkdir -p `dirname $@`/outs
#	python $^ | pigz -p 32 -c > $@
#	touch $@
#
