SHELL := /bin/bash

all: mergelocs_sortconvert.bed post_merge_lengths_sorted.txt final_lengths_sorted.txt mergelocs_2quiv.bed mergelocs_2quiv_1pilon.bed mergelocs_2quiv_2pilon.bed mergelocs_2quiv_2pilon_sortconvert.bed mergelocs_2quiv_2pilon_resort.bed

.PHONY:

.DELETE_ON_ERROR:

mergelocs.bed: merge_annotator.py 02_quivered_initial_assemblies/shrimp_qmerged.hybrid.quiver.fasta 02_quivered_initial_assemblies/shrimp_qmerged.falcon.quiver.fasta merge_out_copy.txt
	python $< -i 02_quivered_initial_assemblies/shrimp_qmerged.hybrid.quiver.fasta -j 02_quivered_initial_assemblies/shrimp_qmerged.falcon.quiver.fasta -l merge_out_copy.txt > $@

mergelocs_sortconvert.bed: name_converter.py 03_merged/merged.fasta 09_renamed2/peromyscus_assembly_polished_v1_shortened_names.fasta mergelocs.bed
	python $< -m 06_merged_2quiv_2pilon/pilon.fasta -s 09_renamed2/peromyscus_assembly_polished_v1_shortened_names.fasta -b mergelocs.bed > $@

post_merge_lengths_sorted.txt: sorted_lengths.py 03_merged/merged.fasta
	python $^ > $@
final_lengths_sorted.txt: sorted_lengths.py 09_renamed2/peromyscus_assembly_polished_v1_shortened_names.fasta
	python $^ > $@

04_merged_2quiv/mut_types.txt: 04_merged_2quiv/shrimp_qmerged.quiver.gff
	cat $< | grep -vE "^#" | cut -d ' ' -f 3 | uniq | sort | uniq > $@

04_merged_2quiv/indels_only.txt: 04_merged_2quiv/shrimp_qmerged.quiver.gff
	cat $< | awk '!/^#/ && $3!="substitution"' > $@

coord_convert_mergelocs_2quiv_quick.txt: indel_adjust_quick.py 04_merged_2quiv/indels_only.txt
	python $^ > $@
mergelocs_1quiv_updatename.bed: mergelocs.bed
	awk -v OFS="\t" -v FS="\t" '{print $$1 "|quiver",$$2,$$3}' $< > $@
mergelocs_2quiv.bed: convert_bed_quick.py mergelocs_1quiv_updatename.bed coord_convert_mergelocs_2quiv_quick.txt
	python $^ > $@
coord_convert_mergelocs_2quiv_1pilon_quick.txt: pilon_indel_adjust_quick.py 05_merged_2quiv_1pilon/indels_only.txt
	python $^ > $@
mergelocs_2quiv_updatename.bed: mergelocs_2quiv.bed
	awk -v OFS="\t" -v FS="\t" '{print $$1 "|pilon",$$2,$$3}' $< > $@
mergelocs_2quiv_1pilon.bed: convert_bed_quick.py mergelocs_2quiv_updatename.bed coord_convert_mergelocs_2quiv_1pilon_quick.txt
	python $^ > $@
coord_convert_mergelocs_2quiv_2pilon_quick.txt: pilon_indel_adjust_quick.py 06_merged_2quiv_2pilon/indels_only.txt
	python $^ > $@
mergelocs_2quiv_1pilon_updatename.bed: mergelocs_2quiv_1pilon.bed
	awk -v OFS="\t" -v FS="\t" '{print $$1 "|pilon",$$2,$$3}' $< > $@
mergelocs_2quiv_2pilon.bed: convert_bed_quick.py mergelocs_2quiv_1pilon_updatename.bed coord_convert_mergelocs_2quiv_2pilon_quick.txt
	python $^ > $@
mergelocs_2quiv_2pilon_updatednames.bed: mergelocs_2quiv_2pilon.bed
	cat $^ | awk -v OFS="\t" '{split($$1,s,"|"); print s[1],$$2,$$3}' > $@
mergelocs_2quiv_2pilon_sortconvert.bed: name_converter.py 06_merged_2quiv_2pilon/pilon.fasta 09_renamed2/peromyscus_assembly_polished_v1_shortened_names.fasta mergelocs_2quiv_2pilon_updatednames.bed
	python $< -m 06_merged_2quiv_2pilon/pilon.fasta -s 09_renamed2/peromyscus_assembly_polished_v1_shortened_names.fasta -b mergelocs_2quiv_2pilon_updatednames.bed > $@
mergelocs_2quiv_2pilon_resort.bed: mergelocs_2quiv_2pilon_sortconvert.bed
	cat $< | sort -k 1,1 -k 2,3n > $@


#./01_initial_assemblies/p_ctg.fa
#./02_quivered_initial_assemblies/shrimp_qmerged.falcon.quiver.fasta
#./02_quivered_initial_assemblies/shrimp_qmerged.hybrid.quiver.fasta
#./03_merged/merged.fasta
#./04_merged_2quiv/shrimp_qmerged.quiver.fasta
#./06_merged_2quiv_2pilon/pilon.fasta
#./07_sorted/pilon_sorted.fasta
#./08_renamed1/peromyscus_assembly_polished_v1.fasta
#./09_renamed2/peromyscus_assembly_polished_v1_shortened_names.fasta
#./Makefile
#./.Makefile.swp
#./merge_annotator_old.py
#./merge_annotator.py
#./merge_out_copy.txt
#./name_converter.py
#./out2.txt
#./out.txt
