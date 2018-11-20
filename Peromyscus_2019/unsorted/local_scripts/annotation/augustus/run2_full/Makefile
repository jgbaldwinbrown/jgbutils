SHELL := /bin/bash

all: augustus_annotation_cleaned_switched_rnatoaugprot.gtf


pairfile_rna_to_aug_prot_switched.txt:
	cat ../../blast_for_grant_blurb/alan_rna_to_aug_prot_v1/alan_rna_to_aug_prot_v1.out | cut -d '     ' -f 1,2 | cut -d '.' -f 1,2 | awk '{print $2 "\t" $1}' > $@

augustus_annotation_cleaned_switched_rnatoaugprot.gff3: find_and_replace_pairs.py pairfile_rna_to_aug_prot_switched_edited.txt augustus_annotation_cleaned.gff3
	python $^ > $@

augustus_annotation_cleaned_switched_rnatoaugprot.gtf: augustus_annotation_cleaned_switched_rnatoaugprot.gff3
	gffread $< -T -o $@

