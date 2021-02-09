#!/bin/bash
set -e

cat ../louseref_untwelve.all.maker.baccut.proteins.fasta.gz | \
gunzip -c | \
bioawk -c fastx '$name~/mRNA-1/{printf(">%s\n%s\n", $name, $seq)}' | \
gzip -c \
> louseref_untwelve.all.maker.baccut.proteins.mainonly.fasta.gz

cat ../louseref_untwelve.all.maker.baccut.transcripts.fasta.gz | \
gunzip -c | \
bioawk -c fastx '$name~/mRNA-1/{printf(">%s\n%s\n", $name, $seq)}' | \
gzip -c \
> louseref_untwelve.all.maker.baccut.transcripts.mainonly.fasta.gz

# grep '^>' | \
# grep 'mRNA-1' | \
# wc -l

# ../louseref.all.sprot.interproscan_tsv.clean.sorted.baccut.gff.gz
# ../louseref_untwelve.all.maker.baccut.proteins.fasta.gz
# ../louseref_untwelve.all.maker.baccut.transcripts.fasta.gz
# ../pigeon_lice_ctgs_breaks_final_baccut.review.fasta.gz
