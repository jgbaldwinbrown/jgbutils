#!/bin/bash

set -e
SWD=`pwd`
mkdir -p temp/split_minion_rna_for_carnac/gmap_chosen
REF=/data1/jbrown/louse_project/test_cout/pigeon_lice_ctgs_breaks_final.review.fasta

for w in 50 100 200 400 ; do
    for m in 10 50 100 200 ; do
        cd $SWD
        mkdir -p temp/split_minion_rna_for_carnac/gmap_chosen/${w}_${m}
        cd ${SWD}/temp/split_minion_rna_for_carnac/chosen_combined_multi/${w}_${m}
        ls all_filt_w*_m*.fa.gz | \
        while read i ; do
            out=${SWD}/temp/split_minion_rna_for_carnac/gmap_chosen/${w}_${m}/`basename ${i} .fa.gz`_filt.bam
            out2=${SWD}/temp/split_minion_rna_for_carnac/gmap_chosen/${w}_${m}/`basename ${i} .fa.gz`_filt_sort.bam
            graphmap align -t 32 -r $REF -d ${i} -o ${out} && \
            samtools sort ${out} > ${out2}
            samtools index ${out2}
        done
    done
done

#graphmap align -t 32 -r /data1/jbrown/louse_project/test_cout/pigeon_lice_ctgs_breaks_final.review.fasta -d scaf3_filt.fa -o scaf3_filt.bam && \
#samtools index scaf3_filt.bam


#all_filt_w400_m100.fa.gz

#graphmap align -t 32 -r ../pigeon_lice_ctgs_breaks_final.review.fasta -d scaf3_filt.fa -o scaf3_filt.bam && \
#samtools index scaf3_filt.bam
#
###v1. align first mrna sequences to incomplete genome using graphmap standard settings
##	graphmap align -r temp/canu/v1/louse_canu_v1.contigs.fasta -d $< -o $@
##	graphmap align -t 16 -r temp/canu/v1/louse_canu_v1.contigs.fasta -d $< -o $@
##	graphmap align -t 16 -r temp/canu/v1/louse_canu_v1.contigs.fasta -d $< -o $@
##	graphmap align -t 16 -r temp/canu/v1/louse_canu_v1.contigs.fasta -d $< -o $@
##	graphmap align -t 16 -r temp/canu/v1/louse_canu_v1.contigs.fasta -d $< -o $@
##	graphmap align -t 16 -r temp/canu/v1/louse_canu_v1.contigs.fasta -d $< -o $@
##	graphmap align -t 16 -r raw_data/hic_scaffold/pigeon_lice_ctgs_breaks_final.review.fasta -d $< -o $@

#/data1/jbrown/louse_project/test_cout/pigeon_lice_ctgs_breaks_final.review.fasta
