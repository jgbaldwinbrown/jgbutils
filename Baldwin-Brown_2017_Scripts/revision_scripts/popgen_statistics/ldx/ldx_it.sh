#!/bin/bash

samtools view -h ../JBB_hb705_unmerged_realigned_deduped2_forsling.bam > JBB_hb705_unmerged_realigned_deduped2_forsling.sam

#set naming variables:
MIN_READ_DEPTH=10
MAX_READ_DEPTH=180
MIN_INTERSECT_DEPTH=11
#samtools command:
./LDx.pl -l ${MIN_READ_DEPTH} -h ${MAX_READ_DEPTH} -i ${MIN_INTERSECT_DEPTH} -s 450 JBB_hb705_unmerged_realigned_deduped2_forsling.sam fortony_vcf_forsling.recode.vcf > ldx_out_forsling.txt


