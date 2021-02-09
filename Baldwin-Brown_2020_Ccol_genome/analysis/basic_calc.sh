#!/bin/bash
set -e

{
    echo "fastats:"
    gunzip -c pigeon_lice_ctgs_breaks_final_baccut.review.fasta.gz | fastats
    echo ""
    
    echo "gff stats:"
    echo "genes:"
    gunzip -c louseref.all.sprot.interproscan_tsv.clean.sorted.baccut.gff.gz | \
    awkf '$3 == "gene"' | \
    wc -l
    echo "transcripts:"
    gunzip -c louseref.all.sprot.interproscan_tsv.clean.sorted.baccut.gff.gz | \
    awkf '$3 == "mRNA"' | \
    wc -l
    echo ""
    
    echo "bp_big_chroms:"
    gunzip -c pigeon_lice_ctgs_breaks_final_baccut.review.fasta.gz | \
    fa2tab | \
    grep -E 'scaffold_(1[0-2]|[0-9])_' | \
    tab2fa | \
    fastats
    echo ""
    
} > stats.txt
