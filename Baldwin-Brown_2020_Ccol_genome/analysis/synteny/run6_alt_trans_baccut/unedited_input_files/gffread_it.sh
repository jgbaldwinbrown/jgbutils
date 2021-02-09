#!/bin/bash
set -e

# gffread \
#     -g <(gunzip -c ../../../pigeon_lice_ctgs_breaks_final.review.fasta.gz) \
#     -x cds.fa \
#     <(gunzip -c ../louseref.all.sprot.interproscan_tsv.gff.gz)
# 
# rm ref_temp.fa
# rm ann_temp.gff

mkdir -p ccolumbae

gunzip -c ../../../pigeon_lice_ctgs_breaks_final_baccut.review.fasta.gz > ref_temp.fa
gunzip -c ../../../louseref.all.sprot.interproscan_tsv.clean.sorted.baccut.gff.gz > ann_temp.gff

gffread \
    -g ref_temp.fa \
    -x ccolumbae/cds.fa \
    ann_temp.gff

rm ref_temp.fa
rm ann_temp.gff

pigz -p 7 ccolumbae/cds.fa
