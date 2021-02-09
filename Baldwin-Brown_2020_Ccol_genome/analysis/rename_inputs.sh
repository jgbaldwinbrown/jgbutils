#!/bin/bash
set -e

mv bads2.gff bads.gff
mv louseref.all.sprot.interproscan_tsv.clean.sorted.baccut{2,}.gff.gz 
mv louseref_untwelve.all.maker.baccut{2,}.proteins.fasta.gz 
mv louseref_untwelve.all.maker.baccut{2,}.transcripts.fasta.gz 
mv pigeon_lice_ctgs_breaks_final_baccut2.review.fasta.gz pigeon_lice_ctgs_breaks_final_baccut.review.fasta.gz 
