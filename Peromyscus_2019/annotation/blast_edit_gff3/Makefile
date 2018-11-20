SHELL := /bin/bash

all: data/modified/augustus_annotation_cleaned.gtf data/modified/augustus_annotation_cleaned_aug_to_mus_all_swapped.gtf data/modified/augustus_annotation_cleaned_aug_to_mus_all_swapped_v2.gtf data/deseq/resFilt_infec_for_deseq_swapped_filtered.txt data/deseq/tissue_deseq/count_data_broadtissue_with_padj_swapped_filtered.txt data/deseq/tissue_deseq/tissue_go_hits.txt data/deseq/infec_go_hits.txt data/deseq/resFilt_infec_for_deseq_filtered.txt

data/modified/augustus_annotation_cleaned.gtf: /Users/jbaldwin/Documents/work_stuff/peromyscus_genome/annotation/augustus/run2_full/augustus_annotation_cleaned.gff3
	gffread $< -T -o $@

#data/modified/aug_to_mus_all_e_cens.txt: scripts/filter_by_column.py ./data/unmodified/outs/aug_prot_to_mus_prot_v1/aug_prot_to_all_mus_prot_v1.out
#	cat ./data/unmodified/outs/aug_prot_to_mus_prot_v1/aug_prot_to_all_mus_prot_v1.out | python $< 10 '<=1e-5' | grep 'Passed' > $@
data/modified/aug_to_mus_all_e_cens.txt: scripts/filter_by_column.py ./data/unmodified/outs/aug_prot_to_mus_prot_v1/aug_prot_to_all_mus_prot_v1.out
	cp ./data/unmodified/outs/aug_prot_to_mus_prot_v1/aug_prot_to_all_mus_prot_v1.out $@
data/modified/aug_to_mus_all_e_cens_pair.txt: data/modified/aug_to_mus_all_e_cens.txt
	cut -d "`printf '\t'`" -f 1,2 $< | sed 's/\.t[0-9]*//g' > $@
data/modified/augustus_annotation_cleaned_aug_to_mus_all_swapped.gtf: scripts/find_and_replace_all_gtf_fields.py data/modified/aug_to_mus_all_e_cens_pair.txt data/modified/augustus_annotation_cleaned.gtf
	python $^ > $@

data/modified/aug_to_mus_all_e_cens_pair_v2.txt: data/modified/aug_to_mus_all_e_cens.txt
	cut -d "`printf '\t'`" -f 1,2 $< | sed 's/\.t[0-9]*//g' | sed 's/	/\.	/g' | sed 's/$$/./g'> $@
data/modified/augustus_annotation_cleaned_aug_to_mus_all_swapped_v2.gtf: scripts/find_and_replace_pairs_v2.py data/modified/aug_to_mus_all_e_cens_pair_v2.txt data/modified/augustus_annotation_cleaned.gtf
	python $^ > $@

data/deseq/resFilt_infec_for_deseq_filtered.txt: scripts/filter_by_column.py data/deseq/resFilt_infec_for_deseq.txt
	cat data/deseq/resFilt_infec_for_deseq.txt | python $< --header 8 '<=0.05' | tee data/deseq/resFilt_infec_for_deseq_tested.txt | grep "Passed" > $@
data/deseq/resFilt_infec_for_deseq_swapped.txt: scripts/find_and_replace_pairs_res.py data/modified/aug_to_mus_all_e_cens_pair.txt data/deseq/resFilt_infec_for_deseq.txt
	python $^ > $@
data/deseq/resFilt_infec_for_deseq_swapped_filtered.txt: scripts/filter_by_column.py data/deseq/resFilt_infec_for_deseq_swapped.txt
	cat data/deseq/resFilt_infec_for_deseq_swapped.txt | python scripts/filter_by_column.py --header 8 '<=0.05' | tee data/deseq/resFilt_infec_for_deseq_swapped_tested.txt | grep "Passed" > $@
data/deseq/all_genes_mus.txt: data/modified/aug_to_mus_all_e_cens_pair_v2.txt
	cat $< | cut -d '	' -f 2 | sed 's/\.//g' | cut -d '|' -f 3 | cut -d '_' -f 1 | sort | uniq > $@
data/deseq/infecsig_genes_mus.txt: data/deseq/resFilt_infec_for_deseq_swapped_filtered.txt
	cat $< | cut -d ' ' -f 2 | sed 's/"//g' | grep -v 'C00' | cut -d '|' -f 3 | cut -d '_' -f 1 | sort | uniq > $@
data/deseq/infec_go_hits.txt: scripts/GOrilla.pl data/deseq/infecsig_genes_mus.txt data/deseq/all_genes_mus.txt
	perl $< --organism MUS_MUSCULUS --runmode hg --name jbaldwin --email jgbaldwinbrown@gmail.com --targets data/deseq/infecsig_genes_mus.txt --background data/deseq/all_genes_mus.txt > $@

data/deseq/tissue_deseq/count_data_broadtissue_with_padj_swapped.txt: scripts/find_and_replace_pairs_counts.py data/modified/aug_to_mus_all_e_cens_pair.txt data/deseq/tissue_deseq/count_data_broadtissue_with_padj.txt
	python $^ > $@
data/deseq/tissue_deseq/count_data_broadtissue_with_padj_swapped_filtered.txt: scripts/filter_by_column.py data/deseq/tissue_deseq/count_data_broadtissue_with_padj_swapped.txt
	cat data/deseq/tissue_deseq/count_data_broadtissue_with_padj_swapped.txt | python scripts/filter_by_column.py --header 17 '<=0.05' | tee data/deseq/tissue_deseq/count_data_broadtissue_with_padj_swapped_tested.txt | grep "Passed" > $@
data/deseq/tissue_deseq/tissuesig_genes_mus.txt: data/deseq/tissue_deseq/count_data_broadtissue_with_padj_swapped_filtered.txt
	cat $< | cut -d ' ' -f 1 | sed 's/"//g' | grep -v 'C00' | cut -d '|' -f 3 | cut -d '_' -f 1 | sort | uniq > $@
data/deseq/tissue_deseq/tissue_go_hits.txt: scripts/GOrilla.pl data/deseq/tissue_deseq/tissuesig_genes_mus.txt data/deseq/all_genes_mus.txt
	perl $< --organism MUS_MUSCULUS --runmode hg --name jbaldwin --email jgbaldwinbrown@gmail.com --targets data/deseq/tissue_deseq/tissuesig_genes_mus.txt --background data/deseq/all_genes_mus.txt > $@


#gene_association/xtxsig_go_hits.txt: GOrilla.pl gene_association/xtxsig_genes.txt gene_association/de_ranked_genes.txt
#	perl $< --organism DROSOPHILA_MELANOGASTER --runmode hg --name jbaldwin --email jbaldwi1@uci.edu --targets gene_association/xtxsig_genes.txt --background gene_association/de_ranked_genes.txt > $@
