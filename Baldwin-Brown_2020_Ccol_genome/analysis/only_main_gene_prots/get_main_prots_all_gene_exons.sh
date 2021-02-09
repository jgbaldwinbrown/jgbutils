#!/bin/bash

gunzip -c ../pigeon_lice_ctgs_breaks_final_baccut.review.fasta.gz | \
fa80 \
> pigeon_lice_ctgs_breaks_final_baccut.review.fasta

gunzip -c ../louseref.all.sprot.interproscan_tsv.clean.sorted.baccut.gff.gz | \
grep '	exon	' \
> louseref.all.sprot.interproscan_tsv.clean.sorted.baccut.exonsonly.gff

bedtools getfasta \
    -fi pigeon_lice_ctgs_breaks_final_baccut.review.fasta \
    -bed louseref.all.sprot.interproscan_tsv.clean.sorted.baccut.exonsonly.gff \
    -fo exons.fa

cat exons.fa | python3 name_exons.py louseref.all.sprot.interproscan_tsv.clean.sorted.baccut.exonsonly.gff out
cat exons.fa | python3 name_and_join_exons.py louseref.all.sprot.interproscan_tsv.clean.sorted.baccut.exonsonly.gff out_correct_joins
