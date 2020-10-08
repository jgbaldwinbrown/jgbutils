SHELL := /bin/bash

PERCENT := %

all: temp/fqjoin/fqjoined.txt all_jellyfish fastqc_all all_binner 180bp_to_human diamond_180bp 180bp_to_pedcons diamond_180bp_mini 180bp_to_clivaexome second_srr_to_clivaexome second_srr_to_pedcons second_srr_to_human diamond_second_srr clamshrimp_to_human clamshrimp_to_pedcons clamshrimp_to_clivaexome diamond_clamshrimp 180bp_to_human_single 180bp_to_pedcons_single 180bp_to_clivaexome_single clamshrimp_to_human_single clamshrimp_to_pedcons_single clamshrimp_to_clivaexome_single diamond_anna_assembly second_srr_paired_to_human minion_qual_test bwa_gatk_outbred2 bwa_gatk_inbred2 minion_qual_test_tom af_bwa_outbred2 af_bwa_inbred2 plot_af_io soap_assembly_unfiltered plat_unfiltered pbchak_hist clc_repmask pedcons_repmask clc_inbred_covcens clc_outbred_covcens covcens_intersect covcens2 plot_af_io_covcens2 covcens_hets basecall_minion minion_tempdist dbg2olc_v2 minion2_dist dbg2olc_v3 canu_v1 dbg2olc_v4 dbg2olc_v5 minion3_dist

clean:
	find temp -type f | grep -v 'git_placeholder.txt' | sort | xargs rm
	find temp -type d -mindepth 1 -empty -delete
full_clean:
	find temp -type f | grep -v 'git_placeholder.txt' | sort | xargs rm
	find temp -type d -mindepth 1 -empty -delete
	find final_files -type f | grep -v 'git_placeholder.txt' | sort | xargs rm
	find final_files -type d -mindepth 1 -empty -delete
archive:
	tar -czvf final.tar.gz final_files
copy_nohups:
	mkdir -p nohup_backups
	cp --backup=t nohup.out nohup_backups/nohup_backup.txt && rm nohup.out

.PHONY: all clean archive copy_nohups fastqc_all inbred_bwa outbred_bwa plat1 filter_data all_jellyfish popoolsync soap_assembly unzip_outbred join_outbred outbred_binner 3500_binner 8200_binner pigeon_sib_binner join_inbred_3500 join_inbred_8200 join_pigeon_sib join_almond_roller almond_roller_binner 180bp_to_human diamond_180bp 180bp_to_pedcons diamond_180bp_v2 diamond_180bp_mini 180bp_to_clivaexome second_srr_to_clivaexome second_srr_to_pedcons second_srr_to_human diamond_second_srr clamshrimp_to_human clamshrimp_to_pedcons clamshrimp_to_clivaexome diamond_clamshrimp megan_tax_files 180bp_to_human_single 180bp_to_pedcons_single 180bp_to_clivaexome_single clamshrimp_to_human_single clamshrimp_to_pedcons_single clamshrimp_to_clivaexome_single diamond_anna_assembly join_clamshrimp clamshrimp_binner second_srr_paired_to_human minion_qual_test minion_qual_test_chris minion_qual_test_anna bwa_gatk_outbred2 bwa_gatk_inbred2 minion_qual_test_tom af_bwa_outbred2 af_bwa_inbred2 plot_af_io soap_assembly_unfiltered plat_unfiltered pbchak_hist clc_repmask pedcons_repmask clc_inbred_covcens clc_outbred_covcens covcens_intersect covcens2 plot_af_io_covcens2 covcens_hets basecall_minion minion_tempdist dbg2olc_v2 minion2_dist dbg2olc_v3 canu_v1 dbg2olc_v4 dbg2olc_v5 minion3_dist minion_rna1-4_dist minion_rna4_dist minion_rna1-3_dist minion_rna3_dist alltrin canu2_repmask
Inbred_bwa: temp/bwa_gatk/anna_assembly_inbred/made_snptable.txt
outbred_bwa: temp/bwa_gatk/anna_assembly_outbred/made_snptable.txt
plat1: temp/platanus/plat_gapclose_done.txt
all_binner: outbred_binner 3500_binner 8200_binner pigeon_sib_binner almond_roller_binner first_srr_binner clamshrimp_binner

################################################################################
################################################################################

#to join read pairs using fqjoin:
temp/fqjoin/fqjoined.txt: scripts/fqjoin/run_fqjoin.sh scripts/fqjoin/to_fqjoin.txt
	-rm temp/fqjoin/fqjoined.txt
	echo {1..4} | tr ' ' '\n' | parallel -j 6 bash $< {}
	touch temp/fqjoin/fqjoined.txt

################################################################################
################################################################################

#to count fqjoined reads using jellyfish:
all_jellyfish: temp/jellyfish/jellyfished.txt temp/jellyfish/jellyfished_unfiltered.txt temp/jellyfish/jellyfished_17mer.txt temp/jellyfish/jellyfished_illinois.txt

temp/jellyfish/jellyfished.txt: scripts/jellyfish/run_jellyfish.sh temp/fqjoin/fqjoined.txt
	-rm temp/jellyfish/jellyfished.txt
	bash $<
	touch temp/jellyfish/jellyfished.txt

temp/jellyfish/jellyfished_unfiltered.txt: scripts/jellyfish/run_jellyfish_unfiltered.sh
	-rm $@
	bash $<
	touch $@

temp/jellyfish/jellyfished_17mer.txt: scripts/jellyfish/run_jellyfish_17mer.sh temp/fqjoin/fqjoined.txt
	-rm $@
	bash $<
	touch $@
temp/jellyfish/jellyfished_15mer.txt: scripts/jellyfish/run_jellyfish_15mer.sh temp/fqjoin/fqjoined.txt
	-rm $@
	bash $<
	touch $@

#count illinois reads with jellyfish:
temp/jellyfish/jellyfished_illinois.txt: scripts/jellyfish/run_jellyfish_illinois.sh
	-rm $@
	mkdir -p `dirname $@`
	bash $<
	touch $@

################################################################################
################################################################################

#to get paths to use for platanus (obsolete?)
temp/platanus/gotpaths.txt: temp/fqjoin/fqjoined.txt
	-rm $@
	find temp/fqjoin -type f -name '*.fq' | grep '180' | grep -v "seqyclean" | sort > temp/platanus/fqjoin_180_paths.txt
	find temp/fqjoin -type f -name '*.fq' | grep '500' | grep -v "seqyclean" | sort > temp/platanus/fqjoin_500_paths.txt
	touch $@

#generate scripts to run later platanus steps:
temp/platanus/run_platanus_scaffold.sh: scripts/platanus/make_runplat_scaffold.py temp/fqjoin/fqjoined.txt
	-rm $@
	python $< 1> $@ 2> temp/platanus/make_runplat_scaffold_err.txt
temp/platanus/run_platanus_gapclose.sh: scripts/platanus/make_runplat_gapclose.py temp/fqjoin/fqjoined.txt
	-rm $@
	python $< 1> $@ 2> temp/platanus/make_runplat_gapclose_err.txt
#run all platanus steps
temp/platanus/plat_assembly_done.txt: scripts/platanus/run_platanus_assemble.sh temp/fqjoin/fqjoined.txt temp/platanus/gotpaths.txt
	-rm $@
	bash $<
	touch $@
temp/platanus/plat_scaffold_done.txt: temp/platanus/run_platanus_scaffold.sh temp/platanus/gotpaths.txt temp/platanus/run_platanus_scaffold.sh temp/platanus/plat_assembly_done.txt
	-rm $@
	bash $<
	touch $@
temp/platanus/plat_gapclose_done.txt: temp/platanus/run_platanus_gapclose.sh temp/platanus/gotpaths.txt temp/platanus/run_platanus_scaffold.sh temp/platanus/plat_scaffold_done.txt
	-rm $@
	bash $<
	touch $@

########################################

#unfiltered platanus:

#join unfiltered 180 and 500bp reads:
temp/fqjoin/fqjoined_unfiltered.txt: scripts/fqjoin/run_fqjoin_unfiltered.sh scripts/fqjoin/to_fqjoin_unfiltered.txt
	-rm temp/fqjoin/fqjoined_unfiltered.txt
	echo {1..2} | tr ' ' '\n' | parallel -j 6 bash $< {}
	touch temp/fqjoin/fqjoined_unfiltered.txt


#to get paths to use for platanus (obsolete?) unfiltered
temp/platanus/gotpaths_unfiltered.txt: temp/fqjoin/fqjoined.txt
	mkdir -p `dirname $@`
	-rm $@
	find temp/fqjoin -type f -name '*.fq' | grep '180' | grep -v "raw" | sort > temp/platanus/fqjoin_180_paths_unfiltered.txt
	find temp/fqjoin -type f -name '*.fq' | grep '500' | grep -v "raw" | sort > temp/platanus/fqjoin_500_paths_unfiltered.txt
	touch $@

#generate scripts to run later platanus unfiltered steps:
temp/platanus/run_platanus_scaffold_unfiltered.sh: scripts/platanus/make_runplat_scaffold_unfiltered.py temp/fqjoin/fqjoined_unfiltered.txt
	-rm $@
	python $< 1> $@ 2> temp/platanus/make_runplat_scaffold_err_unfiltered.txt
temp/platanus/run_platanus_gapclose_unfiltered.sh: scripts/platanus/make_runplat_gapclose_unfiltered.py temp/fqjoin/fqjoined_unfiltered.txt
	-rm $@
	python $< 1> $@ 2> temp/platanus/make_runplat_gapclose_err_unfiltered.txt
#run all platanus unfiltered steps
temp/platanus/plat_assembly_done_unfiltered.txt: scripts/platanus/run_platanus_assemble_unfiltered.sh temp/fqjoin/fqjoined_unfiltered.txt temp/platanus/gotpaths_unfiltered.txt
	mkdir -p `dirname $@`
	-rm $@
	bash $<
	touch $@
temp/platanus/plat_scaffold_done_unfiltered.txt: temp/platanus/run_platanus_scaffold_unfiltered.sh temp/platanus/gotpaths_unfiltered.txt temp/platanus/run_platanus_scaffold_unfiltered.sh temp/platanus/plat_assembly_done_unfiltered.txt
	-rm $@
	bash $<
	touch $@
temp/platanus/plat_gapclose_done_unfiltered.txt: temp/platanus/run_platanus_gapclose_unfiltered.sh temp/platanus/gotpaths_unfiltered.txt temp/platanus/run_platanus_scaffold_unfiltered.sh temp/platanus/plat_scaffold_done_unfiltered.txt
	-rm $@
	bash $<
	touch $@
plat_unfiltered: temp/platanus/plat_gapclose_done_unfiltered.txt

################################################################################
################################################################################

#run bwa and gatk on inbred data:
temp/bwa_gatk/anna_assembly_inbred/gotpaths.txt: temp/fqjoin/fqjoined.txt
	find temp/fqjoin -type f -name '*.fq' | grep -E '\.un1\.' | sort > temp/bwa_gatk/anna_assembly_inbred/fqjoin_unjoined1_paths.txt
	find temp/fqjoin -type f -name '*.fq' | grep -E '\.un2\.' | sort > temp/bwa_gatk/anna_assembly_inbred/fqjoin_unjoined2_paths.txt
	find temp/fqjoin -type f -name '*.fq' | grep -E '\.join\.' | sort > temp/bwa_gatk/anna_assembly_inbred/fqjoin_joined_paths.txt
temp/bwa_gatk/anna_assembly_inbred/indexed.txt: scripts/bwa_gatk/anna_assembly_inbred/align/run1/indexer.sh
	-rm $@
	bash $<
	touch $@
temp/bwa_gatk/anna_assembly_inbred/aligned_sai.txt: scripts/bwa_gatk/anna_assembly_inbred/align/run1/align_sai.sh temp/bwa_gatk/anna_assembly_inbred/indexed.txt
	-rm $@
	bash $<
	touch $@
temp/bwa_gatk/anna_assembly_inbred/prepped_vcf.txt: scripts/bwa_gatk/anna_assembly_inbred/align/run1/prep_vcf.sh temp/bwa_gatk/anna_assembly_inbred/aligned_sai.txt
	-rm $@
	bash $<
	touch $@
temp/bwa_gatk/anna_assembly_inbred/made_vcf.txt: scripts/bwa_gatk/anna_assembly_inbred/align/run1/make_vcf.sh temp/bwa_gatk/anna_assembly_inbred/prepped_vcf.txt
	-rm $@
	bash $<
	touch $@
temp/bwa_gatk/anna_assembly_inbred/made_snptable.txt: scripts/bwa_gatk/anna_assembly_inbred/align/run1/make_snptable.sh temp/bwa_gatk/anna_assembly_inbred/made_vcf.txt
	-rm $@
	bash $<
	touch $@

#temp/bwa_gatk/anna_assembly_inbred/made_freebayes_vcf.txt: temp/bwa_gatk/anna_assembly_inbred/prepped_vcf.txt
#	

#run bwa and gatk on outbred data:
temp/bwa_gatk/anna_assembly_outbred/gotpaths.txt: temp/fqjoin/fqjoined.txt
	find temp/fqjoin -type f -name '*.fq' | grep -E '\.un1\.' | sort > temp/bwa_gatk/anna_assembly_outbred/fqjoin_unjoined1_paths.txt
	find temp/fqjoin -type f -name '*.fq' | grep -E '\.un2\.' | sort > temp/bwa_gatk/anna_assembly_outbred/fqjoin_unjoined2_paths.txt
	find temp/fqjoin -type f -name '*.fq' | grep -E '\.join\.' | sort > temp/bwa_gatk/anna_assembly_outbred/fqjoin_joined_paths.txt
temp/bwa_gatk/anna_assembly_outbred/indexed.txt: scripts/bwa_gatk/anna_assembly_outbred/align/run1/indexer.sh
	-rm $@
	bash $<
	touch $@
temp/bwa_gatk/anna_assembly_outbred/aligned_sai.txt: scripts/bwa_gatk/anna_assembly_outbred/align/run1/align_sai.sh temp/bwa_gatk/anna_assembly_outbred/indexed.txt
	-rm $@
	bash $<
	touch $@
temp/bwa_gatk/anna_assembly_outbred/prepped_vcf.txt: scripts/bwa_gatk/anna_assembly_outbred/align/run1/prep_vcf.sh temp/bwa_gatk/anna_assembly_outbred/aligned_sai.txt
	-rm $@
	bash $<
	touch $@
temp/bwa_gatk/anna_assembly_outbred/made_vcf.txt: scripts/bwa_gatk/anna_assembly_outbred/align/run1/make_vcf.sh temp/bwa_gatk/anna_assembly_outbred/prepped_vcf.txt
	-rm $@
	bash $<
	touch $@
temp/bwa_gatk/anna_assembly_outbred/made_snptable.txt: scripts/bwa_gatk/anna_assembly_outbred/align/run1/make_snptable.sh temp/bwa_gatk/anna_assembly_outbred/made_vcf.txt
	-rm $@
	bash $<
	touch $@

#alternative: popoolation2 sync file to get polymorphism
popoolsync: temp/popoolation/anna_assembly_inbred/madesync.txt temp/popoolation/anna_assembly_outbred/madesync.txt
popoolsyncalt: temp/popoolation/anna_assembly_inbred/madesyncalt.txt temp/popoolation/anna_assembly_outbred/madesyncalt.txt

temp/popoolation/anna_assembly_inbred/madempileup.txt: temp/bwa_gatk/anna_assembly_inbred/prepped_vcf.txt
	mkdir -p `dirname $@`
	-rm $@
	samtools mpileup -B temp/bwa_gatk/anna_assembly_inbred/align/run1/data/bam/louse_inbred_180_500.bam > `dirname $@`/louse_inbred_180_500.mpileup
	touch $@
temp/popoolation/anna_assembly_outbred/madempileup.txt: temp/bwa_gatk/anna_assembly_inbred/prepped_vcf.txt
	mkdir -p `dirname $@`
	-rm $@
	samtools mpileup -B temp/bwa_gatk/anna_assembly_outbred/align/run1/data/bam/louse_outbred_180_500.bam > `dirname $@`/louse_outbred_180_500.mpileup
	touch $@
temp/popoolation/anna_assembly_inbred/madesync.txt: temp/bwa_gatk/anna_assembly_inbred/prepped_vcf.txt temp/popoolation/anna_assembly_inbred/madempileup.txt
	mkdir -p `dirname $@`
	-rm $@
	#/data1/jbrown/local_programs/popoolation2/popoolation2_1201
	java -ea -Xmx64g -jar /data1/jbrown/local_programs/popoolation2/popoolation2_1201/mpileup2sync.jar --input `dirname $@`/louse_inbred_180_500.mpileup --output `dirname $@`/louse_inbred_180_500.sync --fastq-type sanger --min-qual 20 --threads 32
	touch $@
temp/popoolation/anna_assembly_outbred/madesync.txt: temp/bwa_gatk/anna_assembly_outbred/prepped_vcf.txt temp/popoolation/anna_assembly_outbred/madempileup.txt
	mkdir -p `dirname $@`
	-rm $@
	#/data1/jbrown/local_programs/popoolation2/popoolation2_1201
	java -ea -Xmx64g -jar /data1/jbrown/local_programs/popoolation2/popoolation2_1201/mpileup2sync.jar --input `dirname $@`/louse_outbred_180_500.mpileup --output `dirname $@`/louse_outbred_180_500.sync --fastq-type sanger --min-qual 20 --threads 32
	touch $@
temp/popoolation/anna_assembly_inbred/madesyncalt.txt: temp/bwa_gatk/anna_assembly_inbred/prepped_vcf.txt temp/popoolation/anna_assembly_inbred/madempileup.txt
	mkdir -p `dirname $@`
	-rm $@
	#/data1/jbrown/local_programs/popoolation2/popoolation2_1201
	perl /data1/jbrown/local_programs/popoolation2/popoolation2_1201/mpileup2sync.pl --input `dirname $@`/louse_inbred_180_500.mpileup --output `dirname $@`/louse_inbred_180_500_alt.sync --fastq-type sanger --min-qual 20
	touch $@
temp/popoolation/anna_assembly_outbred/madesyncalt.txt: temp/bwa_gatk/anna_assembly_outbred/prepped_vcf.txt temp/popoolation/anna_assembly_outbred/madempileup.txt
	mkdir -p `dirname $@`
	-rm $@
	#/data1/jbrown/local_programs/popoolation2/popoolation2_1201
	perl /data1/jbrown/local_programs/popoolation2/popoolation2_1201/mpileup2sync.pl --input `dirname $@`/louse_outbred_180_500.mpileup --output `dirname $@`/louse_outbred_180_500_alt.sync --fastq-type sanger --min-qual 20
	touch $@

################################################################################
################################################################################

#clean data for second platanus attempt:
filter_data: temp/clean_data/180bp_quaked.txt temp/clean_data/500bp_quaked.txt temp/clean_data/3500bp_quaked.txt temp/clean_data/8200bp_quaked.txt
filter_data_noquake: temp/clean_data/180bp_fqjoined.txt temp/clean_data/500bp_fqjoined.txt temp/clean_data/3500bp_ill_trimmed.txt temp/clean_data/8200bp_prinseq_deduped.txt

#180bp:
temp/clean_data/180bp_ill_combined.txt: scripts/fqjoin/to_fqjoin.txt
	-rm $@
	mkdir -p temp/clean_data/180bp/trimmomatic
	grep -E '5_1' $< | grep -E 'raw\.180' |xargs cat > temp/clean_data/180bp/trimmomatic/indat_f.fq.gz
	grep -E '5_2' $< | grep -E 'raw\.180' |xargs cat > temp/clean_data/180bp/trimmomatic/indat_r.fq.gz
	touch $@
temp/clean_data/180bp_ill_trimmed.txt: raw_data/louse_data_from_anna/binner_180_500_libraries/adapters.fa temp/clean_data/180bp_ill_combined.txt
	-rm $@
	mkdir -p temp/clean_data/180bp/trimmomatic
	a=temp/clean_data/180bp/trimmomatic ; java -jar /data1/jbrown/local_programs/trimmomatic/Trimmomatic-0.36/trimmomatic-0.36.jar PE -threads 8 -phred33 temp/clean_data/180bp/trimmomatic/indat_f.fq.gz temp/clean_data/180bp/trimmomatic/indat_r.fq.gz $${a}/180_trimmed_R1_paired.fq.gz $${a}/180_trimmed_R1_unpaired.fq.gz $${a}/180_trimmed_R2_paired.fq.gz $${a}/180_trimmed_R2_unpaired.fq.gz ILLUMINACLIP:$<:2:30:10 LEADING:20 TRAILING:20 MINLEN:30 CROP:85
	touch $@
temp/clean_data/180bp_fqjoined.txt: scripts/fqjoin/run_fqjoin_v2_180.sh temp/clean_data/180bp_ill_trimmed.txt
	-rm $@
	mkdir -p temp/clean_data/180bp/fqjoin
	a=temp/clean_data/180bp/trimmomatic ; echo -e "$${a}/180_trimmed_R1_paired.fq.gz\n$${a}/180_trimmed_R2_paired.fq.gz\n" > $${a}/180bp_trimmed_to_fqjoin.txt
	echo 1 | tr ' ' '\n' | parallel -j 6 bash $< {}
	touch $@
#temp/clean_data/180bp_jellyfished.txt: scripts/jellyfish/run_jellyfish.sh temp/clean_data/180bp_fqjoined.txt
#	-rm $@
#	jellyfish count -m 21 -s 3000M -t 16 -o temp/jellyfish/louse_ill_joined_21mer_counts.jf -C  1> temp/jellyfish/jellyfish_count_out.txt 2> temp/jellyfish/jellyfish_count_err.txt
#	jellyfish histo temp/jellyfish/louse_ill_joined_21mer_counts.jf  1> temp/jellyfish/louse_ill_joined_21mer_histo.txt 2> temp/jellyfish/jellyfish_histo_err.txt
#	jellyfish dump temp/jellyfish/louse_ill_joined_21mer_counts.jf 1> temp/jellyfish/louse_ill_joined_21mer_counts_dumps.fa 2> temp/jellyfish/jellyfish_dump_err.txt
#	touch $@
temp/clean_data/180bp_quaked.txt: temp/clean_data/180bp_fqjoined.txt
	-rm $@
	mkdir -p temp/clean_data/180bp/quake
	a=`readlink -f temp/clean_data/180bp/fqjoin` ; echo -e "$${a}/180_trimmed_R1_paired.fq.gz.un1.fq\n$${a}/180_trimmed_R1_paired.fq.gz.un2.fq\n" > $${a}/180bp_fqjoined_to_quake.txt
	homepwd=`pwd` ; cd temp/clean_data/180bp/quake ; quake.py --no_jelly -f $${homepwd}/temp/clean_data/180bp/fqjoin/180bp_fqjoined_to_quake.txt -k 19 -p 16 -q 33
	homepwd=`pwd` ; a=temp/clean_data/180bp/fqjoin ; cd temp/clean_data/180bp/quake ; quake.py --no_jelly -r $${homepwd}/$${a}/180_fqjoined.join.fq.gz -k 19 -p 16 -q 33
	a=temp/clean_data/180bp/fqjoin ; find $${a} -name '*cor*' | while read i ; do mv $$i temp/clean_data/180bp/quake
	touch $@

#500bp:
temp/clean_data/500bp_ill_combined.txt: scripts/fqjoin/to_fqjoin.txt
	-rm $@
	mkdir -p temp/clean_data/500bp/trimmomatic
	grep -E '5_1' $< | grep -E 'raw\.500' |xargs cat > temp/clean_data/500bp/trimmomatic/indat_f.fq.gz
	grep -E '5_2' $< | grep -E 'raw\.500' |xargs cat > temp/clean_data/500bp/trimmomatic/indat_r.fq.gz
	touch $@
temp/clean_data/500bp_ill_trimmed.txt: raw_data/louse_data_from_anna/binner_180_500_libraries/adapters.fa temp/clean_data/500bp_ill_combined.txt
	-rm $@
	mkdir -p temp/clean_data/500bp/trimmomatic
	a=temp/clean_data/500bp/trimmomatic ; java -jar /data1/jbrown/local_programs/trimmomatic/Trimmomatic-0.36/trimmomatic-0.36.jar PE -threads 8 -phred33 temp/clean_data/500bp/trimmomatic/indat_f.fq.gz temp/clean_data/500bp/trimmomatic/indat_r.fq.gz $${a}/500_trimmed_R1_paired.fq.gz $${a}/500_trimmed_R1_unpaired.fq.gz $${a}/500_trimmed_R2_paired.fq.gz $${a}/500_trimmed_R2_unpaired.fq.gz ILLUMINACLIP:$<:2:30:10 LEADING:20 TRAILING:20 MINLEN:30 HEADCROP:10
	touch $@
temp/clean_data/500bp_fqjoined.txt: scripts/fqjoin/run_fqjoin_v2_500.sh temp/clean_data/500bp_ill_trimmed.txt
	-rm $@
	mkdir -p temp/clean_data/500bp/fqjoin
	a=temp/clean_data/500bp/trimmomatic ; echo -e "$${a}/500_trimmed_R1_paired.fq.gz\n$${a}/500_trimmed_R2_paired.fq.gz\n" > $${a}/500bp_trimmed_to_fqjoin.txt
	echo 1 | tr ' ' '\n' | parallel -j 6 bash $< {}
	touch $@
temp/clean_data/500bp_quaked.txt: temp/clean_data/500bp_fqjoined.txt
	-rm $@
	mkdir -p temp/clean_data/500bp/quake
	a=`readlink -f temp/clean_data/500bp/fqjoin` ; echo -e "$${a}/500_trimmed_R1_paired.fq.gz.un1.fq\n$${a}/500_trimmed_R1_paired.fq.gz.un2.fq\n" > $${a}/500bp_fqjoined_to_quake.txt
	homepwd=`pwd` ; cd temp/clean_data/500bp/quake ; quake.py --no_jelly -f $${homepwd}/temp/clean_data/500bp/fqjoin/500bp_fqjoined_to_quake.txt -k 19 -p 16 -q 33
	homepwd=`pwd` ; a=temp/clean_data/500bp/fqjoin ; cd temp/clean_data/500bp/quake ; quake.py --no_jelly -r $${homepwd}/$${a}/500_fqjoined.join.fq.gz -k 19 -p 16 -q 33
	a=temp/clean_data/500bp/fqjoin ; find $${a} -name '*cor*' | while read i ; do mv $$i temp/clean_data/500bp/quake
	touch $@

#3500bp:
temp/clean_data/3500bp_ill_combined.txt: /data1/jbrown/louse_project/raw_data/louse_from_mike_dir/all_3500_PE_to_use.txt
	-rm $@
	mkdir -p temp/clean_data/3500bp/trimmomatic
	head -1 $< |xargs cat > temp/clean_data/3500bp/trimmomatic/indat_f.fq.gz
	head -2 $< | tail -n 1 |xargs cat > temp/clean_data/3500bp/trimmomatic/indat_r.fq.gz
	touch $@
temp/clean_data/3500bp_ill_trimmed.txt: raw_data/louse_data_from_anna/binner_180_500_libraries/adapters.fa temp/clean_data/3500bp_ill_combined.txt
	-rm $@
	mkdir -p temp/clean_data/3500bp/trimmomatic
	a=temp/clean_data/3500bp/trimmomatic ; java -jar /data1/jbrown/local_programs/trimmomatic/Trimmomatic-0.36/trimmomatic-0.36.jar PE -threads 8 -phred33 temp/clean_data/3500bp/trimmomatic/indat_f.fq.gz temp/clean_data/3500bp/trimmomatic/indat_r.fq.gz $${a}/3500_trimmed_R1_paired.fq.gz $${a}/3500_trimmed_R1_unpaired.fq.gz $${a}/3500_trimmed_R2_paired.fq.gz $${a}/3500_trimmed_R2_unpaired.fq.gz ILLUMINACLIP:$<:2:30:10 LEADING:20 TRAILING:20 MINLEN:30
	touch $@
temp/clean_data/3500bp_quaked.txt: temp/clean_data/3500bp_ill_trimmed.txt
	-rm $@
	mkdir -p temp/clean_data/3500bp/quake
	a=`readlink -f temp/clean_data/3500bp/trimmomatic` ; echo -e "$${a}/3500_trimmed_R1_paired.fq.gz\n$${a}/3500_trimmed_R2_paired.fq.gz\n" > $${a}/3500bp_trimmed_to_fqjoin.txt
	homepwd=$${PWD} ; cd temp/clean_data/3500bp/quake ; quake.py --no_jelly -f $${homepwd}/temp/clean_data/3500bp/trimmomatic/3500bp_trimmed_to_fqjoin.txt -k 19 -p 16 -q 33
	a=temp/clean_data/3500bp/trimmomatic ; find $${a} -name '*cor*' | while read i ; do mv $$i temp/clean_data/3500bp/quake
	touch $@

#8200bp:
temp/clean_data/8200bp_ill_combined.txt: /data1/jbrown/louse_project/raw_data/louse_from_mike_dir/all_8200_PE_to_use.txt
	-rm $@
	mkdir -p temp/clean_data/8200bp/trimmomatic
	head -1 $< |xargs cat > temp/clean_data/8200bp/trimmomatic/indat_f.fq.gz
	head -2 $< | tail -n 1 |xargs cat > temp/clean_data/8200bp/trimmomatic/indat_r.fq.gz
	touch $@
temp/clean_data/8200bp_ill_trimmed.txt: raw_data/louse_data_from_anna/binner_180_500_libraries/adapters.fa temp/clean_data/8200bp_ill_combined.txt
	-rm $@
	mkdir -p temp/clean_data/8200bp/trimmomatic
	a=temp/clean_data/8200bp/trimmomatic ; java -jar /data1/jbrown/local_programs/trimmomatic/Trimmomatic-0.36/trimmomatic-0.36.jar PE -threads 8 -phred33 temp/clean_data/8200bp/trimmomatic/indat_f.fq.gz temp/clean_data/8200bp/trimmomatic/indat_r.fq.gz $${a}/8200_trimmed_R1_paired.fq.gz $${a}/8200_trimmed_R1_unpaired.fq.gz $${a}/8200_trimmed_R2_paired.fq.gz $${a}/8200_trimmed_R2_unpaired.fq.gz ILLUMINACLIP:$<:2:30:10 LEADING:20 TRAILING:20 MINLEN:30
	touch $@
temp/clean_data/8200bp_ill_trimmed_gunzipped1.txt: temp/clean_data/8200bp_ill_trimmed.txt
	-rm $@
	a=temp/clean_data/8200bp/trimmomatic ; gunzip -c $${a}/8200_trimmed_R1_paired.fq.gz > $${a}/8200_trimmed_R1_paired.fq
	touch $@
temp/clean_data/8200bp_ill_trimmed_gunzipped2.txt: temp/clean_data/8200bp_ill_trimmed.txt
	-rm $@
	a=temp/clean_data/8200bp/trimmomatic ; gunzip -c $${a}/8200_trimmed_R2_paired.fq.gz > $${a}/8200_trimmed_R2_paired.fq
	touch $@
temp/clean_data/8200bp_prinseq_deduped.txt: temp/clean_data/8200bp_ill_trimmed_gunzipped1.txt temp/clean_data/8200bp_ill_trimmed_gunzipped2.txt
	-rm $@
	mkdir -p temp/clean_data/8200bp/prinseq
	inpath=temp/clean_data/8200bp/trimmomatic ; outpath=temp/clean_data/8200bp/prinseq ; prinseq-lite.pl -fastq $${inpath}/8200_trimmed_R1_paired.fq -fastq2 $${inpath}/8200_trimmed_R2_paired.fq -out_good $${outpath}/8200_prinseqed -out_bad $${outpath}/8200_prinseqed_bad -derep 1
	touch $@
temp/clean_data/8200bp_quaked.txt: temp/clean_data/8200bp_prinseq_deduped.txt
	-rm $@
	mkdir -p temp/clean_data/8200bp/quake
	a=`readlink -f temp/clean_data/8200bp/prinseq` ; echo -e "$${a}/8200_prinseqed_1.fq\n$${a}/8200_prinseqed_2\n" > $${a}/8200bp_prinseqed_to_quake.txt
	homepwd=`pwd` ; cd temp/clean_data/8200bp/quake ; quake.py --no_jelly -f $${homepwd}/temp/clean_data/8200bp/prinseq/8200bp_prinseqed_to_quake.txt -k 19 -p 16 -q 33
	a=temp/clean_data/8200bp/prinseq ; find $${a} -name '*cor*' | while read i ; do mv $$i temp/clean_data/8200bp/quake
	touch $@

################################################################################
################################################################################

soap_assembly: temp/soap/annarun1/soap_assembled.txt temp/soap/annarun1/soapstats.txt
temp/soap/annarun1/soap_assembled.txt: scripts/soap/run_soap_v1.sh filter_data_noquake scripts/soap/annarun_config_1.txt
	-rm $@
	mkdir -p `dirname $@`
	bash $<
	touch $@
temp/soap/annarun1/soapstats.txt: scripts/util/fastats.py temp/soap/annarun1/soap_assembled.txt
	-rm $@
	python $< temp/soap/annarun1/shrimp_soap_assembly_v1.scafSeq > $@

########################################

soap_assembly_unfiltered: temp/soap/unfiltered/soap_assembled.txt temp/soap/unfiltered/soapstats.txt
temp/soap/unfiltered/soap_assembled.txt: scripts/soap/run_soap_v2.sh scripts/soap/annarun_config_2.txt
	-rm $@
	mkdir -p `dirname $@`
	bash $<
	touch $@
temp/soap/unfiltered/soapstats.txt: scripts/util/fastats.py temp/soap/unfiltered/soap_assembled.txt
	-rm $@
	python $< temp/soap/unfiltered/shrimp_soap_assembly_v2.scafSeq > $@

################################################################################
################################################################################

unzip_outbred: temp/binner/louse_outbred_bigdb/louse_outbred_rawdat1.fq temp/binner/louse_outbred_bigdb/louse_outbred_rawdat2.fq
temp/binner/louse_outbred_bigdb/louse_outbred_rawdat1.fq: /data1/jbrown/louse_project/raw_data/louse_from_mike/LICE/Columbicola_HCI_0213/9784R/Fastq/9784X1_130125_SN1117_0139_AC1J93ACXX_5_1.txt.gz
	gunzip -c $< > $@
temp/binner/louse_outbred_bigdb/louse_outbred_rawdat2.fq: /data1/jbrown/louse_project/raw_data/louse_from_mike/LICE/Columbicola_HCI_0213/9784R/Fastq/9784X1_130125_SN1117_0139_AC1J93ACXX_5_2.txt.gz
	gunzip -c $< > $@
join_outbred: temp/binner/louse_outbred_bigdb/louse_outbred_rawdat_joined.fa
temp/binner/louse_outbred_bigdb/louse_outbred_rawdat_joined.fa: /data1/jbrown/louse_project/raw_data/louse_from_mike/LICE/Columbicola_HCI_0213/9784R/Fastq/9784X1_130125_SN1117_0139_AC1J93ACXX_5_1.txt.gz /data1/jbrown/louse_project/raw_data/louse_from_mike/LICE/Columbicola_HCI_0213/9784R/Fastq/9784X1_130125_SN1117_0139_AC1J93ACXX_5_2.txt.gz
	mkdir -p `dirname $@`
	python scripts/binner/join_reads.py <(gunzip -c /data1/jbrown/louse_project/raw_data/louse_from_mike/LICE/Columbicola_HCI_0213/9784R/Fastq/9784X1_130125_SN1117_0139_AC1J93ACXX_5_1.txt.gz) <(gunzip -c /data1/jbrown/louse_project/raw_data/louse_from_mike/LICE/Columbicola_HCI_0213/9784R/Fastq/9784X1_130125_SN1117_0139_AC1J93ACXX_5_2.txt.gz) > $@

outbred_binner: temp/binner/louse_outbred_bigdb/louse_outbred_bigdb_parsed.txt temp/binner/louse_outbred_customdb/louse_outbred_customdb_parsed.txt
temp/binner/louse_outbred_bigdb/louse_outbred_bigdb_done.txt: scripts/binner/binner_outbred_bigdb.sh scripts/binner/louse_outbred_bigdb.conf temp/binner/louse_outbred_bigdb/louse_outbred_rawdat_joined.fa
	-rm $@
	mkdir -p `dirname $@`
	bash $<
	touch $@
temp/binner/louse_outbred_bigdb/louse_outbred_bigdb_parsed.txt: temp/binner/louse_outbred_bigdb/louse_outbred_bigdb_done.txt scripts/binner/parse_binner_output.v2.py
	-rm $@
	python scripts/binner/parse_binner_output.v2.py -i temp/binner/louse_outbred_bigdb/louse_outbred_bigdb.out -c 0.3 -o temp/binner/louse_outbred_bigdb/louse_outbred_bigdb_parsed.txt > temp/binner/louse_outbred_bigdb/louse_outbred_bigdb_parse.log 2>&1
	touch $@
temp/binner/louse_outbred_customdb/louse_outbred_customdb_done.txt: scripts/binner/binner_outbred_customdb.sh scripts/binner/louse_outbred_customdb.conf temp/binner/louse_outbred_bigdb/louse_outbred_rawdat_joined.fa
	-rm $@
	mkdir -p `dirname $@`
	bash $<
	touch $@
temp/binner/louse_outbred_customdb/louse_outbred_customdb_parsed.txt: temp/binner/louse_outbred_customdb/louse_outbred_customdb_done.txt scripts/binner/parse_Cliv-binner_output.v2.py
	-rm $@
	python scripts/binner/parse_Cliv-binner_output.v2.py -i temp/binner/louse_outbred_customdb/louse_outbred_customdb.out -c 0.3 -o temp/binner/louse_outbred_customdb/louse_outbred_customdb_parsed.txt > temp/binner/louse_outbred_customdb/louse_outbred_customdb_parse.log 2>&1
	touch $@

3500_binner: temp/binner/louse_inbred_3500_customdb/louse_inbred_3500_customdb_parsed.txt temp/binner/louse_inbred_3500_bigdb/louse_inbred_3500_bigdb_parsed.txt
join_inbred_3500: temp/binner/louse_inbred_3500_bigdb/louse_inbred_3500_rawdat_joined.fa
temp/binner/louse_inbred_3500_bigdb/louse_inbred_3500_rawdat_joined.fa: scripts/binner/join_reads.py /data1/jbrown/louse_project/raw_data/louse_from_mike_dir/columbicola_3500_seqyclean_PE1.fastq.gz /data1/jbrown/louse_project/raw_data/louse_from_mike_dir/columbicola_3500_seqyclean_PE2.fastq.gz
	mkdir -p `dirname $@`
	python $< <(gunzip -c /data1/jbrown/louse_project/raw_data/louse_from_mike_dir/columbicola_3500_seqyclean_PE1.fastq.gz) <(gunzip -c /data1/jbrown/louse_project/raw_data/louse_from_mike_dir/columbicola_3500_seqyclean_PE2.fastq.gz) > $@
temp/binner/louse_inbred_3500_bigdb/louse_inbred_3500_bigdb_done.txt: scripts/binner/louse_inbred_3500_bigdb.conf temp/binner/louse_inbred_3500_bigdb/louse_inbred_3500_rawdat_joined.fa
	-rm $@
	mkdir -p `dirname $@`
	bin_reads scripts/binner/louse_inbred_3500_bigdb.conf -c 0.3 > `dirname $@`/louse_inbred_3500_bigdb.log 2>&1
	touch $@
temp/binner/louse_inbred_3500_bigdb/louse_inbred_3500_bigdb_parsed.txt: temp/binner/louse_inbred_3500_bigdb/louse_inbred_3500_bigdb_done.txt scripts/binner/parse_binner_output.v2.py
	-rm $@
	python scripts/binner/parse_binner_output.v2.py -i temp/binner/louse_inbred_3500_bigdb/louse_inbred_3500_bigdb.out -c 0.3 -o temp/binner/louse_inbred_3500_bigdb/louse_inbred_3500_bigdb_parsed.txt > temp/binner/louse_inbred_3500_bigdb/louse_inbred_3500_bigdb_parse.log 2>&1
	touch $@
temp/binner/louse_inbred_3500_customdb/louse_inbred_3500_customdb_done.txt: scripts/binner/louse_inbred_3500_customdb.conf temp/binner/louse_inbred_3500_bigdb/louse_inbred_3500_rawdat_joined.fa
	-rm $@
	mkdir -p `dirname $@`
	bin_reads scripts/binner/louse_inbred_3500_customdb.conf -c 0.3 > `dirname $@`/louse_inbred_3500_customdb.log 2>&1
	touch $@
temp/binner/louse_inbred_3500_customdb/louse_inbred_3500_customdb_parsed.txt: temp/binner/louse_inbred_3500_customdb/louse_inbred_3500_customdb_done.txt scripts/binner/parse_Cliv-binner_output.v2.py
	-rm $@
	python scripts/binner/parse_Cliv-binner_output.v2.py -i temp/binner/louse_inbred_3500_customdb/louse_inbred_3500_customdb.out -c 0.3 -o temp/binner/louse_inbred_3500_customdb/louse_inbred_3500_customdb_parsed.txt > temp/binner/louse_inbred_3500_customdb/louse_inbred_3500_customdb_parse.log 2>&1
	touch $@

8200_binner: temp/binner/louse_inbred_8200_customdb/louse_inbred_8200_customdb_parsed.txt temp/binner/louse_inbred_8200_bigdb/louse_inbred_8200_bigdb_parsed.txt
join_inbred_8200: temp/binner/louse_inbred_8200_bigdb/louse_inbred_8200_rawdat_joined.fa
temp/binner/louse_inbred_8200_bigdb/louse_inbred_8200_rawdat_joined.fa: scripts/binner/join_reads.py /data1/jbrown/louse_project/raw_data/louse_from_mike_dir/columbicola_8200_seqyclean_PE1.fastq.gz /data1/jbrown/louse_project/raw_data/louse_from_mike_dir/columbicola_8200_seqyclean_PE2.fastq.gz
	mkdir -p `dirname $@`
	python $< <(gunzip -c /data1/jbrown/louse_project/raw_data/louse_from_mike_dir/columbicola_8200_seqyclean_PE1.fastq.gz) <(gunzip -c /data1/jbrown/louse_project/raw_data/louse_from_mike_dir/columbicola_8200_seqyclean_PE2.fastq.gz) > $@
temp/binner/louse_inbred_8200_bigdb/louse_inbred_8200_bigdb_done.txt: scripts/binner/louse_inbred_8200_bigdb.conf temp/binner/louse_inbred_8200_bigdb/louse_inbred_8200_rawdat_joined.fa
	-rm $@
	mkdir -p `dirname $@`
	bin_reads scripts/binner/louse_inbred_8200_bigdb.conf -c 0.3 > `dirname $@`/louse_inbred_8200_bigdb.log 2>&1
	touch $@
temp/binner/louse_inbred_8200_bigdb/louse_inbred_8200_bigdb_parsed.txt: temp/binner/louse_inbred_8200_bigdb/louse_inbred_8200_bigdb_done.txt scripts/binner/parse_binner_output.v2.py
	-rm $@
	python scripts/binner/parse_binner_output.v2.py -i temp/binner/louse_inbred_8200_bigdb/louse_inbred_8200_bigdb.out -c 0.3 -o temp/binner/louse_inbred_8200_bigdb/louse_inbred_8200_bigdb_parsed.txt > temp/binner/louse_inbred_8200_bigdb/louse_inbred_8200_bigdb_parse.log 2>&1
	touch $@
temp/binner/louse_inbred_8200_customdb/louse_inbred_8200_customdb_done.txt: scripts/binner/louse_inbred_8200_customdb.conf temp/binner/louse_inbred_8200_bigdb/louse_inbred_8200_rawdat_joined.fa
	-rm $@
	mkdir -p `dirname $@`
	bin_reads scripts/binner/louse_inbred_8200_customdb.conf -c 0.3 > `dirname $@`/louse_inbred_8200_customdb.log 2>&1
	touch $@
temp/binner/louse_inbred_8200_customdb/louse_inbred_8200_customdb_parsed.txt: temp/binner/louse_inbred_8200_customdb/louse_inbred_8200_customdb_done.txt scripts/binner/parse_Cliv-binner_output.v2.py
	-rm $@
	python scripts/binner/parse_Cliv-binner_output.v2.py -i temp/binner/louse_inbred_8200_customdb/louse_inbred_8200_customdb.out -c 0.3 -o temp/binner/louse_inbred_8200_customdb/louse_inbred_8200_customdb_parsed.txt > temp/binner/louse_inbred_8200_customdb/louse_inbred_8200_customdb_parse.log 2>&1
	touch $@

pigeon_sib_binner: temp/binner/louse_pigeon_sib_customdb/louse_pigeon_sib_customdb_parsed.txt temp/binner/louse_pigeon_sib_bigdb/louse_pigeon_sib_bigdb_parsed.txt
join_pigeon_sib: temp/binner/louse_pigeon_sib_bigdb/louse_pigeon_sib_rawdat_joined.fa
temp/binner/louse_pigeon_sib_bigdb/louse_pigeon_sib_rawdat_joined.fa: scripts/binner/join_reads.py /data1/jbrown/louse_project/raw_data/pigeon/pigeon_sib_180_R1.fq.gz /data1/jbrown/louse_project/raw_data/pigeon/pigeon_sib_180_R2.fq.gz
	mkdir -p `dirname $@`
	python $< <(gunzip -c /data1/jbrown/louse_project/raw_data/pigeon/pigeon_sib_180_R1.fq.gz) <(gunzip -c /data1/jbrown/louse_project/raw_data/pigeon/pigeon_sib_180_R1.fq.gz) > $@
temp/binner/louse_pigeon_sib_bigdb/louse_pigeon_sib_bigdb_done.txt: scripts/binner/louse_pigeon_sib_bigdb.conf temp/binner/louse_pigeon_sib_bigdb/louse_pigeon_sib_rawdat_joined.fa
	-rm $@
	mkdir -p `dirname $@`
	bin_reads scripts/binner/louse_pigeon_sib_bigdb.conf -c 0.3 > `dirname $@`/louse_pigeon_sib_bigdb.log 2>&1
	touch $@
temp/binner/louse_pigeon_sib_bigdb/louse_pigeon_sib_bigdb_parsed.txt: temp/binner/louse_pigeon_sib_bigdb/louse_pigeon_sib_bigdb_done.txt scripts/binner/parse_binner_output.v2.py
	-rm $@
	python scripts/binner/parse_binner_output.v2.py -i temp/binner/louse_pigeon_sib_bigdb/louse_pigeon_sib_bigdb.out -c 0.3 -o temp/binner/louse_pigeon_sib_bigdb/louse_pigeon_sib_bigdb_parsed.txt > temp/binner/louse_pigeon_sib_bigdb/louse_pigeon_sib_bigdb_parse.log 2>&1
	touch $@
temp/binner/louse_pigeon_sib_customdb/louse_pigeon_sib_customdb_done.txt: scripts/binner/louse_pigeon_sib_customdb.conf temp/binner/louse_pigeon_sib_bigdb/louse_pigeon_sib_rawdat_joined.fa
	-rm $@
	mkdir -p `dirname $@`
	bin_reads scripts/binner/louse_pigeon_sib_customdb.conf -c 0.3 > `dirname $@`/louse_pigeon_sib_customdb.log 2>&1
	touch $@
temp/binner/louse_pigeon_sib_customdb/louse_pigeon_sib_customdb_parsed.txt: temp/binner/louse_pigeon_sib_customdb/louse_pigeon_sib_customdb_done.txt scripts/binner/parse_Cliv-binner_output.v2.py
	-rm $@
	python scripts/binner/parse_Cliv-binner_output.v2.py -i temp/binner/louse_pigeon_sib_customdb/louse_pigeon_sib_customdb.out -c 0.3 -o temp/binner/louse_pigeon_sib_customdb/louse_pigeon_sib_customdb_parsed.txt > temp/binner/louse_pigeon_sib_customdb/louse_pigeon_sib_customdb_parse.log 2>&1
	touch $@

almond_roller_binner: temp/binner/louse_almond_roller_customdb/louse_almond_roller_customdb_parsed.txt temp/binner/louse_almond_roller_bigdb/louse_almond_roller_bigdb_parsed.txt
join_almond_roller: temp/binner/louse_almond_roller_bigdb/louse_almond_roller_rawdat_joined.fa
temp/binner/louse_almond_roller_bigdb/louse_almond_roller_rawdat_joined.fa: scripts/binner/join_reads.py
	mkdir -p `dirname $@`
	python $< <(gunzip -c <(cat raw_data/pigeon/almond_roller/*R1.fq.gz)) <(gunzip -c <(cat raw_data/pigeon/almond_roller/*R2.fq.gz)) > $@
temp/binner/louse_almond_roller_bigdb/louse_almond_roller_bigdb_done.txt: scripts/binner/louse_almond_roller_bigdb.conf temp/binner/louse_almond_roller_bigdb/louse_almond_roller_rawdat_joined.fa
	-rm $@
	mkdir -p `dirname $@`
	bin_reads scripts/binner/louse_almond_roller_bigdb.conf -c 0.3 > `dirname $@`/louse_almond_roller_bigdb.log 2>&1
	touch $@
temp/binner/louse_almond_roller_bigdb/louse_almond_roller_bigdb_parsed.txt: temp/binner/louse_almond_roller_bigdb/louse_almond_roller_bigdb_done.txt scripts/binner/parse_binner_output.v2.py
	-rm $@
	python scripts/binner/parse_binner_output.v2.py -i temp/binner/louse_almond_roller_bigdb/louse_almond_roller_bigdb.out -c 0.3 -o temp/binner/louse_almond_roller_bigdb/louse_almond_roller_bigdb_parsed.txt > temp/binner/louse_almond_roller_bigdb/louse_almond_roller_bigdb_parse.log 2>&1
	touch $@
temp/binner/louse_almond_roller_customdb/louse_almond_roller_customdb_done.txt: scripts/binner/louse_almond_roller_customdb.conf temp/binner/louse_almond_roller_bigdb/louse_almond_roller_rawdat_joined.fa
	-rm $@
	mkdir -p `dirname $@`
	bin_reads scripts/binner/louse_almond_roller_customdb.conf -c 0.3 > `dirname $@`/louse_almond_roller_customdb.log 2>&1
	touch $@
temp/binner/louse_almond_roller_customdb/louse_almond_roller_customdb_parsed.txt: temp/binner/louse_almond_roller_customdb/louse_almond_roller_customdb_done.txt scripts/binner/parse_Cliv-binner_output.v2.py
	-rm $@
	python scripts/binner/parse_Cliv-binner_output.v2.py -i temp/binner/louse_almond_roller_customdb/louse_almond_roller_customdb.out -c 0.3 -o temp/binner/louse_almond_roller_customdb/louse_almond_roller_customdb_parsed.txt > temp/binner/louse_almond_roller_customdb/louse_almond_roller_customdb_parse.log 2>&1
	touch $@

raw_data/louse_data_sra/first_srr_from_bioproject/downloaded.txt:
	-rm $@
	fastq-dump -O raw_data/louse_data_sra/first_srr_from_bioproject SRR3161972
	touch $@
raw_data/louse_data_sra/first_srr_from_bioproject/downloaded_new.txt:
	-rm $@
	fastq-dump --split-3 -O raw_data/louse_data_sra/first_srr_from_bioproject SRR3161972
	touch $@
first_srr_binner: temp/binner/louse_first_srr_customdb/louse_first_srr_customdb_parsed.txt temp/binner/louse_first_srr_bigdb/louse_first_srr_bigdb_parsed.txt
temp/binner/louse_first_srr_bigdb/louse_first_srr_rawdat_joined.fa: raw_data/louse_data_sra/first_srr_from_bioproject/downloaded.txt
	mkdir -p `dirname $@`
	cat raw_data/louse_data_sra/first_srr_from_bioproject/SRR3161972.fastq | sed -n '1~4s/^@/>/p;2~4p' > $@
temp/binner/louse_first_srr_bigdb/louse_first_srr_bigdb_done.txt: scripts/binner/louse_first_srr_bigdb.conf temp/binner/louse_first_srr_bigdb/louse_first_srr_rawdat_joined.fa
	-rm $@
	mkdir -p `dirname $@`
	bin_reads scripts/binner/louse_first_srr_bigdb.conf -c 0.3 > `dirname $@`/louse_first_srr_bigdb.log 2>&1
	touch $@
temp/binner/louse_first_srr_bigdb/louse_first_srr_bigdb_parsed.txt: temp/binner/louse_first_srr_bigdb/louse_first_srr_bigdb_done.txt scripts/binner/parse_binner_output.v2.py
	-rm $@
	python scripts/binner/parse_binner_output.v2.py -i temp/binner/louse_first_srr_bigdb/louse_first_srr_bigdb.out -c 0.3 -o temp/binner/louse_first_srr_bigdb/louse_first_srr_bigdb_parsed.txt > temp/binner/louse_first_srr_bigdb/louse_first_srr_bigdb_parse.log 2>&1
	touch $@
temp/binner/louse_first_srr_customdb/louse_first_srr_customdb_done.txt: scripts/binner/louse_first_srr_customdb.conf temp/binner/louse_first_srr_bigdb/louse_first_srr_rawdat_joined.fa
	-rm $@
	mkdir -p `dirname $@`
	bin_reads scripts/binner/louse_first_srr_customdb.conf -c 0.3 > `dirname $@`/louse_first_srr_customdb.log 2>&1
	touch $@
temp/binner/louse_first_srr_customdb/louse_first_srr_customdb_parsed.txt: temp/binner/louse_first_srr_customdb/louse_first_srr_customdb_done.txt scripts/binner/parse_Cliv-binner_output.v2.py
	-rm $@
	python scripts/binner/parse_Cliv-binner_output.v2.py -i temp/binner/louse_first_srr_customdb/louse_first_srr_customdb.out -c 0.3 -o temp/binner/louse_first_srr_customdb/louse_first_srr_customdb_parsed.txt > temp/binner/louse_first_srr_customdb/louse_first_srr_customdb_parse.log 2>&1
	touch $@
raw_data/louse_data_sra/first_srr_v2_from_bioproject/downloaded.txt:
	-rm $@
	fastq-dump -O raw_data/louse_data_sra/first_srr_v2_from_bioproject SRR3161972
	touch $@
first_srr_v2_binner: temp/binner/louse_first_srr_v2_customdb/louse_first_srr_v2_customdb_parsed.txt temp/binner/louse_first_srr_v2_bigdb/louse_first_srr_v2_bigdb_parsed.txt
temp/binner/louse_first_srr_v2_bigdb/louse_first_srr_v2_rawdat_joined.fa: raw_data/louse_data_sra/first_srr_v2_from_bioproject/downloaded.txt
	mkdir -p `dirname $@`
	cat raw_data/louse_data_sra/first_srr_v2_from_bioproject/SRR3161972.fastq | sed -n '1~4s/^@/>/p;2~4p' > $@
temp/binner/louse_first_srr_v2_bigdb/louse_first_srr_v2_bigdb_done.txt: scripts/binner/louse_first_srr_v2_bigdb.conf temp/binner/louse_first_srr_v2_bigdb/louse_first_srr_v2_rawdat_joined.fa
	-rm $@
	mkdir -p `dirname $@`
	bin_reads scripts/binner/louse_first_srr_v2_bigdb.conf -c 0.3 > `dirname $@`/louse_first_srr_v2_bigdb.log 2>&1
	touch $@
temp/binner/louse_first_srr_v2_bigdb/louse_first_srr_v2_bigdb_parsed.txt: temp/binner/louse_first_srr_v2_bigdb/louse_first_srr_v2_bigdb_done.txt scripts/binner/parse_binner_output.v2.py
	-rm $@
	python scripts/binner/parse_binner_output.v2.py -i temp/binner/louse_first_srr_v2_bigdb/louse_first_srr_v2_bigdb.out -c 0.3 -o temp/binner/louse_first_srr_v2_bigdb/louse_first_srr_v2_bigdb_parsed.txt > temp/binner/louse_first_srr_v2_bigdb/louse_first_srr_v2_bigdb_parse.log 2>&1
	touch $@

#SRR3161917
#run taxonomer on random columbicola from Illinois:
raw_data/louse_data_sra/second_srr_from_bioproject/downloaded.txt:
	-rm $@
	fastq-dump -O raw_data/louse_data_sra/second_srr_from_bioproject SRR3161917
	touch $@
raw_data/louse_data_sra/second_srr_from_bioproject/downloaded_new.txt:
	-rm $@
	fastq-dump --split-3 -O raw_data/louse_data_sra/second_srr_from_bioproject SRR3161917
	touch $@
second_srr_binner: temp/binner/louse_second_srr_customdb/louse_second_srr_customdb_parsed.txt temp/binner/louse_second_srr_bigdb/louse_second_srr_bigdb_parsed.txt
temp/binner/louse_second_srr_bigdb/louse_second_srr_rawdat_joined.fa: raw_data/louse_data_sra/second_srr_from_bioproject/downloaded.txt
	mkdir -p `dirname $@`
	cat raw_data/louse_data_sra/second_srr_from_bioproject/SRR3161917.fastq | sed -n '1~4s/^@/>/p;2~4p' > $@
temp/binner/louse_second_srr_bigdb/louse_second_srr_bigdb_done.txt: scripts/binner/louse_second_srr_bigdb.conf temp/binner/louse_second_srr_bigdb/louse_second_srr_rawdat_joined.fa
	-rm $@
	mkdir -p `dirname $@`
	bin_reads scripts/binner/louse_second_srr_bigdb.conf -c 0.3 > `dirname $@`/louse_second_srr_bigdb.log 2>&1
	touch $@
temp/binner/louse_second_srr_bigdb/louse_second_srr_bigdb_parsed.txt: temp/binner/louse_second_srr_bigdb/louse_second_srr_bigdb_done.txt scripts/binner/parse_binner_output.v2.py
	-rm $@
	python scripts/binner/parse_binner_output.v2.py -i temp/binner/louse_second_srr_bigdb/louse_second_srr_bigdb.out -c 0.3 -o temp/binner/louse_second_srr_bigdb/louse_second_srr_bigdb_parsed.txt > temp/binner/louse_second_srr_bigdb/louse_second_srr_bigdb_parse.log 2>&1
	touch $@
temp/binner/louse_second_srr_customdb/louse_second_srr_customdb_done.txt: scripts/binner/louse_second_srr_customdb.conf temp/binner/louse_second_srr_bigdb/louse_second_srr_rawdat_joined.fa
	-rm $@
	mkdir -p `dirname $@`
	bin_reads scripts/binner/louse_second_srr_customdb.conf -c 0.3 > `dirname $@`/louse_second_srr_customdb.log 2>&1
	touch $@
temp/binner/louse_second_srr_customdb/louse_second_srr_customdb_parsed.txt: temp/binner/louse_second_srr_customdb/louse_second_srr_customdb_done.txt scripts/binner/parse_Cliv-binner_output.v2.py
	-rm $@
	python scripts/binner/parse_Cliv-binner_output.v2.py -i temp/binner/louse_second_srr_customdb/louse_second_srr_customdb.out -c 0.3 -o temp/binner/louse_second_srr_customdb/louse_second_srr_customdb_parsed.txt > temp/binner/louse_second_srr_customdb/louse_second_srr_customdb_parse.log 2>&1
	touch $@

#run taxonomer on clam shrimp data:
join_clamshrimp: temp/binner/louse_clamshrimp_bigdb/louse_clamshrimp_rawdat_joined.fa
temp/binner/louse_clamshrimp_bigdb/louse_clamshrimp_rawdat_joined.fa: raw_data/clam_shrimp/R111-L6-READ1-Sequences.txt.gz raw_data/clam_shrimp/R111-L6-READ2-Sequences.txt.gz
	mkdir -p `dirname $@`
	python scripts/binner/join_reads.py <(gunzip -c raw_data/clam_shrimp/R111-L6-READ1-Sequences.txt.gz) <(gunzip -c raw_data/clam_shrimp/R111-L6-READ2-Sequences.txt.gz) > $@

clamshrimp_binner: temp/binner/louse_clamshrimp_bigdb/louse_clamshrimp_bigdb_parsed.txt temp/binner/louse_clamshrimp_customdb/louse_clamshrimp_customdb_parsed.txt
temp/binner/louse_clamshrimp_bigdb/louse_clamshrimp_bigdb_done.txt: scripts/binner/binner_clamshrimp_bigdb.sh scripts/binner/louse_clamshrimp_bigdb.conf temp/binner/louse_clamshrimp_bigdb/louse_clamshrimp_rawdat_joined.fa
	-rm $@
	mkdir -p `dirname $@`
	bash $<
	touch $@
temp/binner/louse_clamshrimp_bigdb/louse_clamshrimp_bigdb_parsed.txt: temp/binner/louse_clamshrimp_bigdb/louse_clamshrimp_bigdb_done.txt scripts/binner/parse_binner_output.v2.py
	-rm $@
	python scripts/binner/parse_binner_output.v2.py -i temp/binner/louse_clamshrimp_bigdb/louse_clamshrimp_bigdb.out -c 0.3 -o temp/binner/louse_clamshrimp_bigdb/louse_clamshrimp_bigdb_parsed.txt > temp/binner/louse_clamshrimp_bigdb/louse_clamshrimp_bigdb_parse.log 2>&1
	touch $@
temp/binner/louse_clamshrimp_customdb/louse_clamshrimp_customdb_done.txt: scripts/binner/binner_clamshrimp_customdb.sh scripts/binner/louse_clamshrimp_customdb.conf temp/binner/louse_clamshrimp_bigdb/louse_clamshrimp_rawdat_joined.fa
	-rm $@
	mkdir -p `dirname $@`
	bash $<
	touch $@
temp/binner/louse_clamshrimp_customdb/louse_clamshrimp_customdb_parsed.txt: temp/binner/louse_clamshrimp_customdb/louse_clamshrimp_customdb_done.txt scripts/binner/parse_Cliv-binner_output.v2.py
	-rm $@
	python scripts/binner/parse_Cliv-binner_output.v2.py -i temp/binner/louse_clamshrimp_customdb/louse_clamshrimp_customdb.out -c 0.3 -o temp/binner/louse_clamshrimp_customdb/louse_clamshrimp_customdb_parsed.txt > temp/binner/louse_clamshrimp_customdb/louse_clamshrimp_customdb_parse.log 2>&1
	touch $@

################################################################################
################################################################################

#version 2 of bwa_cov_check, using bwa mem and updated scripts:
180bp_to_human: temp/bwa_cov_check2/human_ref/180bp_to_humref_summary.txt
180bp_to_human_fast: temp/bwa_cov_check2/human_ref/180bp_to_humref_sam_fast.txt 
temp/bwa_cov_check2/human_ref/humref_ref.txt:
	mkdir -p `dirname $@`
	-rm $@
	rsync -avp raw_data/refs/human/gcf_000001405.36_grch38.p10_genomic.fa `dirname $@`/humref.fa
	touch $@
temp/bwa_cov_check2/human_ref/humref_indexed.txt: scripts/bwa_cov_check2/full_index.sh temp/bwa_cov_check2/human_ref/humref_ref.txt
	mkdir -p `dirname $@`
	-rm $@
	bash $< `dirname $@`/humref.fa
	touch $@
temp/bwa_cov_check2/human_ref/180bp_to_humref_sam.txt: temp/bwa_cov_check2/human_ref/humref_indexed.txt
	mkdir -p `dirname $@`
	-rm $@
	bwa mem -t 16 -r '@rg\tid:180bp_reads\tsm:louse_ref\tlb:180bp_ill' `dirname $@`/humref.fa raw_data/louse_from_mike_dir/duplicates_removed/columbicola_180_seqyclean_PE1.fastq.gz raw_data/louse_from_mike_dir/duplicates_removed/columbicola_180_seqyclean_pe2.fastq.gz > `dirname $@`/180bp_to_humref_raw.sam
	touch $@
temp/bwa_cov_check2/human_ref/180bp_to_humref_sam_fast.txt: temp/bwa_cov_check2/human_ref/humref_indexed.txt
	mkdir -p `dirname $@`
	-rm $@
	bwa mem -t 16 -r '@rg\tid:180bp_reads\tsm:louse_ref\tlb:180bp_ill' `dirname $@`/humref.fa raw_data/louse_from_mike_dir/duplicates_removed/columbicola_180_seqyclean_PE1.fastq.gz raw_data/louse_from_mike_dir/duplicates_removed/columbicola_180_seqyclean_pe2.fastq.gz > `dirname $@`/180bp_to_humref_raw_fast.sam
	touch $@
temp/bwa_cov_check2/human_ref/180bp_to_humref_fixedbam.txt: temp/bwa_cov_check2/human_ref/180bp_to_humref_sam.txt
	mkdir -p `dirname $@`
	-rm $@
	samtools fixmate -O bam `dirname $@`/180bp_to_humref_raw.sam `dirname $@`/180bp_to_humref_fixedbam.bam
	touch $@
temp/bwa_cov_check2/human_ref/180bp_to_humref_sortedbam.txt: temp/bwa_cov_check2/human_ref/180bp_to_humref_fixedbam.txt
	mkdir -p `dirname $@`
	-rm $@
	samtools sort -O bam -o `dirname $@`/180bp_to_humref_sortedbam.bam -T tmp/180bp_to_humref `dirname $@`/180bp_to_humref_fixedbam.bam
	touch $@
temp/bwa_cov_check2/human_ref/180bp_to_humref_summary.txt: temp/bwa_cov_check2/human_ref/180bp_to_humref_sortedbam.txt
	mkdir -p `dirname $@`
	-rm $@
	samtools flagstat `dirname $@`/180bp_to_humref_sortedbam.bam > $@
	touch $@

180bp_to_human_single: temp/bwa_cov_check2/human_ref/180bp_to_humrefsingle_summary.txt
temp/bwa_cov_check2/human_ref/180bp_to_humrefsingle_sam.txt: temp/bwa_cov_check2/human_ref/humref_indexed.txt
	mkdir -p `dirname $@`
	-rm $@
	bwa mem -t 16 -r '@rg\tid:180bp_reads\tsm:louse_ref\tlb:180bp_ill' `dirname $@`/humref.fa raw_data/louse_from_mike_dir/duplicates_removed/columbicola_180_seqyclean_PE1.fastq.gz  > `dirname $@`/180bp_to_humrefsingle_raw.sam
	touch $@
temp/bwa_cov_check2/human_ref/180bp_to_humrefsingle_fixedbam.txt: temp/bwa_cov_check2/human_ref/180bp_to_humrefsingle_sam.txt
	mkdir -p `dirname $@`
	-rm $@
	samtools fixmate -O bam `dirname $@`/180bp_to_humrefsingle_raw.sam `dirname $@`/180bp_to_humrefsingle_fixedbam.bam
	touch $@
temp/bwa_cov_check2/human_ref/180bp_to_humrefsingle_sortedbam.txt: temp/bwa_cov_check2/human_ref/180bp_to_humrefsingle_fixedbam.txt
	mkdir -p `dirname $@`
	-rm $@
	samtools sort -O bam -o `dirname $@`/180bp_to_humrefsingle_sortedbam.bam -T tmp/180bp_to_humrefsingle `dirname $@`/180bp_to_humrefsingle_fixedbam.bam
	touch $@
temp/bwa_cov_check2/human_ref/180bp_to_humrefsingle_summary.txt: temp/bwa_cov_check2/human_ref/180bp_to_humrefsingle_sortedbam.txt
	mkdir -p `dirname $@`
	-rm $@
	samtools flagstat `dirname $@`/180bp_to_humrefsingle_sortedbam.bam > $@
	touch $@


180bp_to_pedcons: temp/bwa_cov_check2/pediculus_blasted_contigs/180bp_to_pedcons_summary.txt
180bp_to_pedcons_fast: temp/bwa_cov_check2/pediculus_blasted_contigs/180bp_to_pedcons_sam_fast.txt 
temp/bwa_cov_check2/pediculus_blasted_contigs/pedcons_ref.txt: scripts/util/exact_search_fasta.py raw_data/previous_assemblies/taxon_filtered_louse/pediculus_blasted_contigs.txt raw_data/previous_assemblies/taxon_filtered_louse/ALM_F2Male_MDS349_CLCassembly.fasta
	mkdir -p `dirname $@`
	-rm $@
	cat raw_data/previous_assemblies/taxon_filtered_louse/pediculus_blasted_contigs.txt | while read i ; do python $< $$i raw_data/previous_assemblies/taxon_filtered_louse/ALM_F2Male_MDS349_CLCassembly.fasta ; done > `dirname $@`/pedcons.fa
	touch $@
temp/bwa_cov_check2/pediculus_blasted_contigs/pedcons_indexed.txt: scripts/bwa_cov_check2/full_index.sh temp/bwa_cov_check2/pediculus_blasted_contigs/pedcons_ref.txt
	mkdir -p `dirname $@`
	-rm $@
	bash $< `dirname $@`/pedcons.fa
	touch $@
temp/bwa_cov_check2/pediculus_blasted_contigs/180bp_to_pedcons_sam.txt: temp/bwa_cov_check2/pediculus_blasted_contigs/pedcons_indexed.txt
	mkdir -p `dirname $@`
	-rm $@
	bwa mem -t 16 -r '@rg\tid:180bp_reads\tsm:louse_ref\tlb:180bp_ill' `dirname $@`/pedcons.fa raw_data/louse_from_mike_dir/duplicates_removed/columbicola_180_seqyclean_PE1.fastq.gz raw_data/louse_from_mike_dir/duplicates_removed/columbicola_180_seqyclean_pe2.fastq.gz > `dirname $@`/180bp_to_pedcons_raw.sam
	touch $@
temp/bwa_cov_check2/pediculus_blasted_contigs/180bp_to_pedcons_sam_fast.txt: temp/bwa_cov_check2/pediculus_blasted_contigs/pedcons_indexed.txt
	mkdir -p `dirname $@`
	-rm $@
	bwa mem -t 16 -r '@rg\tid:180bp_reads\tsm:louse_ref\tlb:180bp_ill' `dirname $@`/pedcons.fa raw_data/louse_from_mike_dir/duplicates_removed/columbicola_180_seqyclean_PE1.fastq.gz raw_data/louse_from_mike_dir/duplicates_removed/columbicola_180_seqyclean_pe2.fastq.gz > `dirname $@`/180bp_to_pedcons_raw_fast.sam
	touch $@
temp/bwa_cov_check2/pediculus_blasted_contigs/180bp_to_pedcons_fixedbam.txt: temp/bwa_cov_check2/pediculus_blasted_contigs/180bp_to_pedcons_sam.txt
	mkdir -p `dirname $@`
	-rm $@
	samtools fixmate -O bam `dirname $@`/180bp_to_pedcons_raw.sam `dirname $@`/180bp_to_pedcons_fixedbam.bam
	touch $@
temp/bwa_cov_check2/pediculus_blasted_contigs/180bp_to_pedcons_sortedbam.txt: temp/bwa_cov_check2/pediculus_blasted_contigs/180bp_to_pedcons_fixedbam.txt
	mkdir -p `dirname $@`
	-rm $@
	samtools sort -O bam -o `dirname $@`/180bp_to_pedcons_sortedbam.bam -T tmp/180bp_to_pedcons `dirname $@`/180bp_to_pedcons_fixedbam.bam
	touch $@
temp/bwa_cov_check2/pediculus_blasted_contigs/180bp_to_pedcons_summary.txt: temp/bwa_cov_check2/pediculus_blasted_contigs/180bp_to_pedcons_sortedbam.txt
	mkdir -p `dirname $@`
	-rm $@
	samtools flagstat `dirname $@`/180bp_to_pedcons_sortedbam.bam > $@
	touch $@

180bp_to_pedcons_single: temp/bwa_cov_check2/pediculus_blasted_contigs/180bp_to_pedconssingle_summary.txt
temp/bwa_cov_check2/pediculus_blasted_contigs/180bp_to_pedconssingle_sam.txt: temp/bwa_cov_check2/pediculus_blasted_contigs/pedcons_indexed.txt
	mkdir -p `dirname $@`
	-rm $@
	bwa mem -t 16 -r '@rg\tid:180bp_reads\tsm:louse_ref\tlb:180bp_ill' `dirname $@`/pedcons.fa raw_data/louse_from_mike_dir/duplicates_removed/columbicola_180_seqyclean_PE1.fastq.gz > `dirname $@`/180bp_to_pedconssingle_raw.sam
	touch $@
temp/bwa_cov_check2/pediculus_blasted_contigs/180bp_to_pedconssingle_fixedbam.txt: temp/bwa_cov_check2/pediculus_blasted_contigs/180bp_to_pedconssingle_sam.txt
	mkdir -p `dirname $@`
	-rm $@
	samtools fixmate -O bam `dirname $@`/180bp_to_pedconssingle_raw.sam `dirname $@`/180bp_to_pedconssingle_fixedbam.bam
	touch $@
temp/bwa_cov_check2/pediculus_blasted_contigs/180bp_to_pedconssingle_sortedbam.txt: temp/bwa_cov_check2/pediculus_blasted_contigs/180bp_to_pedconssingle_fixedbam.txt
	mkdir -p `dirname $@`
	-rm $@
	samtools sort -O bam -o `dirname $@`/180bp_to_pedconssingle_sortedbam.bam -T tmp/180bp_to_pedconssingle `dirname $@`/180bp_to_pedconssingle_fixedbam.bam
	touch $@
temp/bwa_cov_check2/pediculus_blasted_contigs/180bp_to_pedconssingle_summary.txt: temp/bwa_cov_check2/pediculus_blasted_contigs/180bp_to_pedconssingle_sortedbam.txt
	mkdir -p `dirname $@`
	-rm $@
	samtools flagstat `dirname $@`/180bp_to_pedconssingle_sortedbam.bam > $@
	touch $@
#align 180bp to columbicola liva:
#raw_data/louse_exome/align_6_to_ped/dryad_anoplura_data/columbicola_liva_exome_combo.fa
180bp_to_clivaexome: temp/bwa_cov_check2/c_liva_exome/180bp_to_clivaexome_summary.txt 
temp/bwa_cov_check2/c_liva_exome/clivaexome_ref.txt:
	mkdir -p `dirname $@`
	-rm $@
	rsync -avp raw_data/louse_exome/align_6_to_ped/dryad_anoplura_data/columbicola_liva_exome_combo.fa `dirname $@`/clivaexome.fa
	touch $@
temp/bwa_cov_check2/c_liva_exome/clivaexome_indexed.txt: scripts/bwa_cov_check2/full_index.sh temp/bwa_cov_check2/c_liva_exome/clivaexome_ref.txt
	mkdir -p `dirname $@`
	-rm $@
	bash $< `dirname $@`/clivaexome.fa
	touch $@
temp/bwa_cov_check2/c_liva_exome/180bp_to_clivaexome_sam.txt: temp/bwa_cov_check2/c_liva_exome/clivaexome_indexed.txt
	mkdir -p `dirname $@`
	-rm $@
	bwa mem -t 16 -r '@rg\tid:180bp_reads\tsm:louse_ref\tlb:180bp_ill' `dirname $@`/clivaexome.fa raw_data/louse_from_mike_dir/duplicates_removed/columbicola_180_seqyclean_PE1.fastq.gz raw_data/louse_from_mike_dir/duplicates_removed/columbicola_180_seqyclean_pe2.fastq.gz > `dirname $@`/180bp_to_clivaexome_raw.sam
	touch $@
temp/bwa_cov_check2/c_liva_exome/180bp_to_clivaexome_fixedbam.txt: temp/bwa_cov_check2/c_liva_exome/180bp_to_clivaexome_sam.txt
	mkdir -p `dirname $@`
	-rm $@
	samtools fixmate -O bam `dirname $@`/180bp_to_clivaexome_raw.sam `dirname $@`/180bp_to_clivaexome_fixedbam.bam
	touch $@
temp/bwa_cov_check2/c_liva_exome/180bp_to_clivaexome_sortedbam.txt: temp/bwa_cov_check2/c_liva_exome/180bp_to_clivaexome_fixedbam.txt
	mkdir -p `dirname $@`
	-rm $@
	samtools sort -O bam -o `dirname $@`/180bp_to_clivaexome_sortedbam.bam -T tmp/180bp_to_clivaexome `dirname $@`/180bp_to_clivaexome_fixedbam.bam
	touch $@
temp/bwa_cov_check2/c_liva_exome/180bp_to_clivaexome_summary.txt: temp/bwa_cov_check2/c_liva_exome/180bp_to_clivaexome_sortedbam.txt
	mkdir -p `dirname $@`
	-rm $@
	samtools flagstat `dirname $@`/180bp_to_clivaexome_sortedbam.bam > $@
	touch $@

180bp_to_clivaexome_single: temp/bwa_cov_check2/c_liva_exome/180bp_to_clivaexomesingle_summary.txt 
temp/bwa_cov_check2/c_liva_exome/180bp_to_clivaexomesingle_sam.txt: temp/bwa_cov_check2/c_liva_exome/clivaexome_indexed.txt
	mkdir -p `dirname $@`
	-rm $@
	bwa mem -t 16 -r '@rg\tid:180bp_reads\tsm:louse_ref\tlb:180bp_ill' `dirname $@`/clivaexome.fa raw_data/louse_from_mike_dir/duplicates_removed/columbicola_180_seqyclean_PE1.fastq.gz raw_data/louse_from_mike_dir/duplicates_removed/columbicola_180_seqyclean_pe2.fastq.gz > `dirname $@`/180bp_to_clivaexomesingle_raw.sam
	touch $@
temp/bwa_cov_check2/c_liva_exome/180bp_to_clivaexomesingle_fixedbam.txt: temp/bwa_cov_check2/c_liva_exome/180bp_to_clivaexomesingle_sam.txt
	mkdir -p `dirname $@`
	-rm $@
	samtools fixmate -O bam `dirname $@`/180bp_to_clivaexomesingle_raw.sam `dirname $@`/180bp_to_clivaexomesingle_fixedbam.bam
	touch $@
temp/bwa_cov_check2/c_liva_exome/180bp_to_clivaexomesingle_sortedbam.txt: temp/bwa_cov_check2/c_liva_exome/180bp_to_clivaexomesingle_fixedbam.txt
	mkdir -p `dirname $@`
	-rm $@
	samtools sort -O bam -o `dirname $@`/180bp_to_clivaexomesingle_sortedbam.bam -T tmp/180bp_to_clivaexomesingle `dirname $@`/180bp_to_clivaexomesingle_fixedbam.bam
	touch $@
temp/bwa_cov_check2/c_liva_exome/180bp_to_clivaexomesingle_summary.txt: temp/bwa_cov_check2/c_liva_exome/180bp_to_clivaexomesingle_sortedbam.txt
	mkdir -p `dirname $@`
	-rm $@
	samtools flagstat `dirname $@`/180bp_to_clivaexomesingle_sortedbam.bam > $@
	touch $@

#second srr to various things:
#raw_data/louse_data_sra/second_srr_from_bioproject/srr3161917.fastq
second_srr_to_human: temp/bwa_cov_check2/human_ref/second_srr_to_humref_summary.txt
temp/bwa_cov_check2/human_ref/second_srr_to_humref_sam.txt: temp/bwa_cov_check2/human_ref/humref_indexed.txt
	mkdir -p `dirname $@`
	-rm $@
	bwa mem -t 16 -r '@rg\tid:second_srr_reads\tsm:louse_ref\tlb:second_srr_ill' `dirname $@`/humref.fa raw_data/louse_data_sra/second_srr_from_bioproject/srr3161917.fastq > `dirname $@`/second_srr_to_humref_raw.sam
	touch $@
temp/bwa_cov_check2/human_ref/second_srr_to_humref_fixedbam.txt: temp/bwa_cov_check2/human_ref/second_srr_to_humref_sam.txt
	mkdir -p `dirname $@`
	-rm $@
	samtools fixmate -O bam `dirname $@`/second_srr_to_humref_raw.sam `dirname $@`/second_srr_to_humref_fixedbam.bam
	touch $@
temp/bwa_cov_check2/human_ref/second_srr_to_humref_sortedbam.txt: temp/bwa_cov_check2/human_ref/second_srr_to_humref_fixedbam.txt
	mkdir -p `dirname $@`
	-rm $@
	samtools sort -O bam -o `dirname $@`/second_srr_to_humref_sortedbam.bam -T tmp/second_srr_to_humref `dirname $@`/second_srr_to_humref_fixedbam.bam
	touch $@
temp/bwa_cov_check2/human_ref/second_srr_to_humref_summary.txt: temp/bwa_cov_check2/human_ref/second_srr_to_humref_sortedbam.txt
	mkdir -p `dirname $@`
	-rm $@
	samtools flagstat `dirname $@`/second_srr_to_humref_sortedbam.bam > $@
	touch $@

second_srr_paired_to_human: temp/bwa_cov_check2/human_ref/second_srr_paired_to_humref_summary.txt
temp/bwa_cov_check2/human_ref/second_srr_paired_to_humref_sam.txt: temp/bwa_cov_check2/human_ref/humref_indexed.txt
	mkdir -p `dirname $@`
	-rm $@
	bwa mem -t 16 -r '@rg\tid:second_srr_paired_reads\tsm:louse_ref\tlb:second_srr_paired_ill' `dirname $@`/humref.fa raw_data/louse_data_sra/second_srr_from_bioproject/SRR3161917_1.fastq raw_data/louse_data_sra/second_srr_from_bioproject/SRR3161917_2.fastq > `dirname $@`/second_srr_paired_to_humref_raw.sam
	touch $@
temp/bwa_cov_check2/human_ref/second_srr_paired_to_humref_fixedbam.txt: temp/bwa_cov_check2/human_ref/second_srr_paired_to_humref_sam.txt
	mkdir -p `dirname $@`
	-rm $@
	samtools fixmate -O bam `dirname $@`/second_srr_paired_to_humref_raw.sam `dirname $@`/second_srr_paired_to_humref_fixedbam.bam
	touch $@
temp/bwa_cov_check2/human_ref/second_srr_paired_to_humref_sortedbam.txt: temp/bwa_cov_check2/human_ref/second_srr_paired_to_humref_fixedbam.txt
	mkdir -p `dirname $@`
	-rm $@
	samtools sort -O bam -o `dirname $@`/second_srr_paired_to_humref_sortedbam.bam -T tmp/second_srr_paired_to_humref `dirname $@`/second_srr_paired_to_humref_fixedbam.bam
	touch $@
temp/bwa_cov_check2/human_ref/second_srr_paired_to_humref_summary.txt: temp/bwa_cov_check2/human_ref/second_srr_paired_to_humref_sortedbam.txt
	mkdir -p `dirname $@`
	-rm $@
	samtools flagstat `dirname $@`/second_srr_paired_to_humref_sortedbam.bam > $@
	touch $@


second_srr_to_pedcons: temp/bwa_cov_check2/pediculus_blasted_contigs/second_srr_to_pedcons_summary.txt
temp/bwa_cov_check2/pediculus_blasted_contigs/second_srr_to_pedcons_sam.txt: temp/bwa_cov_check2/pediculus_blasted_contigs/pedcons_indexed.txt
	mkdir -p `dirname $@`
	-rm $@
	bwa mem -t 16 -r '@rg\tid:second_srr_reads\tsm:louse_ref\tlb:second_srr_ill' `dirname $@`/pedcons.fa raw_data/louse_data_sra/second_srr_from_bioproject/srr3161917.fastq > `dirname $@`/second_srr_to_pedcons_raw.sam
	touch $@
temp/bwa_cov_check2/pediculus_blasted_contigs/second_srr_to_pedcons_fixedbam.txt: temp/bwa_cov_check2/pediculus_blasted_contigs/second_srr_to_pedcons_sam.txt
	mkdir -p `dirname $@`
	-rm $@
	samtools fixmate -O bam `dirname $@`/second_srr_to_pedcons_raw.sam `dirname $@`/second_srr_to_pedcons_fixedbam.bam
	touch $@
temp/bwa_cov_check2/pediculus_blasted_contigs/second_srr_to_pedcons_sortedbam.txt: temp/bwa_cov_check2/pediculus_blasted_contigs/second_srr_to_pedcons_fixedbam.txt
	mkdir -p `dirname $@`
	-rm $@
	samtools sort -O bam -o `dirname $@`/second_srr_to_pedcons_sortedbam.bam -T tmp/second_srr_to_pedcons `dirname $@`/second_srr_to_pedcons_fixedbam.bam
	touch $@
temp/bwa_cov_check2/pediculus_blasted_contigs/second_srr_to_pedcons_summary.txt: temp/bwa_cov_check2/pediculus_blasted_contigs/second_srr_to_pedcons_sortedbam.txt
	mkdir -p `dirname $@`
	-rm $@
	samtools flagstat `dirname $@`/second_srr_to_pedcons_sortedbam.bam > $@
	touch $@

second_srr_to_clivaexome: temp/bwa_cov_check2/c_liva_exome/second_srr_to_clivaexome_summary.txt 
temp/bwa_cov_check2/c_liva_exome/second_srr_to_clivaexome_sam.txt: temp/bwa_cov_check2/c_liva_exome/clivaexome_indexed.txt
	mkdir -p `dirname $@`
	-rm $@
	bwa mem -t 16 -r '@rg\tid:second_srr_reads\tsm:louse_ref\tlb:second_srr_ill' `dirname $@`/clivaexome.fa raw_data/louse_data_sra/second_srr_from_bioproject/srr3161917.fastq > `dirname $@`/second_srr_to_clivaexome_raw.sam
	touch $@
temp/bwa_cov_check2/c_liva_exome/second_srr_to_clivaexome_fixedbam.txt: temp/bwa_cov_check2/c_liva_exome/second_srr_to_clivaexome_sam.txt
	mkdir -p `dirname $@`
	-rm $@
	samtools fixmate -O bam `dirname $@`/second_srr_to_clivaexome_raw.sam `dirname $@`/second_srr_to_clivaexome_fixedbam.bam
	touch $@
temp/bwa_cov_check2/c_liva_exome/second_srr_to_clivaexome_sortedbam.txt: temp/bwa_cov_check2/c_liva_exome/second_srr_to_clivaexome_fixedbam.txt
	mkdir -p `dirname $@`
	-rm $@
	samtools sort -O bam -o `dirname $@`/second_srr_to_clivaexome_sortedbam.bam -T tmp/second_srr_to_clivaexome `dirname $@`/second_srr_to_clivaexome_fixedbam.bam
	touch $@
temp/bwa_cov_check2/c_liva_exome/second_srr_to_clivaexome_summary.txt: temp/bwa_cov_check2/c_liva_exome/second_srr_to_clivaexome_sortedbam.txt
	mkdir -p `dirname $@`
	-rm $@
	samtools flagstat `dirname $@`/second_srr_to_clivaexome_sortedbam.bam > $@
	touch $@

#clam shrimp bwas:
clamshrimp_to_human: temp/bwa_cov_check2/human_ref/clamshrimp_to_humref_summary.txt
temp/bwa_cov_check2/human_ref/clamshrimp_to_humref_sam.txt: temp/bwa_cov_check2/human_ref/humref_indexed.txt
	mkdir -p `dirname $@`
	-rm $@
	bwa mem -t 16 -r '@rg\tid:clamshrimp_reads\tsm:louse_ref\tlb:clamshrimp_ill' `dirname $@`/humref.fa /data1/jbrown/louse_project/raw_data/clam_shrimp/R111-L6-READ1-Sequences.txt.gz /data1/jbrown/louse_project/raw_data/clam_shrimp/R111-L6-READ2-Sequences.txt.gz > `dirname $@`/clamshrimp_to_humref_raw.sam
	touch $@
temp/bwa_cov_check2/human_ref/clamshrimp_to_humref_fixedbam.txt: temp/bwa_cov_check2/human_ref/clamshrimp_to_humref_sam.txt
	mkdir -p `dirname $@`
	-rm $@
	samtools fixmate -O bam `dirname $@`/clamshrimp_to_humref_raw.sam `dirname $@`/clamshrimp_to_humref_fixedbam.bam
	touch $@
temp/bwa_cov_check2/human_ref/clamshrimp_to_humref_sortedbam.txt: temp/bwa_cov_check2/human_ref/clamshrimp_to_humref_fixedbam.txt
	mkdir -p `dirname $@`
	-rm $@
	samtools sort -O bam -o `dirname $@`/clamshrimp_to_humref_sortedbam.bam -T tmp/clamshrimp_to_humref `dirname $@`/clamshrimp_to_humref_fixedbam.bam
	touch $@
temp/bwa_cov_check2/human_ref/clamshrimp_to_humref_summary.txt: temp/bwa_cov_check2/human_ref/clamshrimp_to_humref_sortedbam.txt
	mkdir -p `dirname $@`
	-rm $@
	samtools flagstat `dirname $@`/clamshrimp_to_humref_sortedbam.bam > $@
	touch $@

clamshrimp_to_pedcons: temp/bwa_cov_check2/pediculus_blasted_contigs/clamshrimp_to_pedcons_summary.txt
temp/bwa_cov_check2/pediculus_blasted_contigs/clamshrimp_to_pedcons_sam.txt: temp/bwa_cov_check2/pediculus_blasted_contigs/pedcons_indexed.txt
	mkdir -p `dirname $@`
	-rm $@
	bwa mem -t 16 -R '@RG\tID:clamshrimp_reads\tSM:louse_ref\tLB:clamshrimp_ill' `dirname $@`/pedcons.fa /data1/jbrown/louse_project/raw_data/clam_shrimp/R111-L6-READ1-Sequences.txt.gz /data1/jbrown/louse_project/raw_data/clam_shrimp/R111-L6-READ2-Sequences.txt.gz > `dirname $@`/clamshrimp_to_pedcons_raw.sam
	touch $@
temp/bwa_cov_check2/pediculus_blasted_contigs/clamshrimp_to_pedcons_fixedbam.txt: temp/bwa_cov_check2/pediculus_blasted_contigs/clamshrimp_to_pedcons_sam.txt
	mkdir -p `dirname $@`
	-rm $@
	samtools fixmate -O bam `dirname $@`/clamshrimp_to_pedcons_raw.sam `dirname $@`/clamshrimp_to_pedcons_fixedbam.bam
	touch $@
temp/bwa_cov_check2/pediculus_blasted_contigs/clamshrimp_to_pedcons_sortedbam.txt: temp/bwa_cov_check2/pediculus_blasted_contigs/clamshrimp_to_pedcons_fixedbam.txt
	mkdir -p `dirname $@`
	-rm $@
	samtools sort -O bam -o `dirname $@`/clamshrimp_to_pedcons_sortedbam.bam -T tmp/clamshrimp_to_pedcons `dirname $@`/clamshrimp_to_pedcons_fixedbam.bam
	touch $@
temp/bwa_cov_check2/pediculus_blasted_contigs/clamshrimp_to_pedcons_summary.txt: temp/bwa_cov_check2/pediculus_blasted_contigs/clamshrimp_to_pedcons_sortedbam.txt
	mkdir -p `dirname $@`
	-rm $@
	samtools flagstat `dirname $@`/clamshrimp_to_pedcons_sortedbam.bam > $@
	touch $@

clamshrimp_to_clivaexome: temp/bwa_cov_check2/c_liva_exome/clamshrimp_to_clivaexome_summary.txt 
temp/bwa_cov_check2/c_liva_exome/clamshrimp_to_clivaexome_sam.txt: temp/bwa_cov_check2/c_liva_exome/clivaexome_indexed.txt
	mkdir -p `dirname $@`
	-rm $@
	bwa mem -t 16 -R '@RG\tID:clamshrimp_reads\tSM:louse_ref\tLB:clamshrimp_ill' `dirname $@`/clivaexome.fa /data1/jbrown/louse_project/raw_data/clam_shrimp/R111-L6-READ1-Sequences.txt.gz /data1/jbrown/louse_project/raw_data/clam_shrimp/R111-L6-READ2-Sequences.txt.gz > `dirname $@`/clamshrimp_to_clivaexome_raw.sam
	touch $@
temp/bwa_cov_check2/c_liva_exome/clamshrimp_to_clivaexome_fixedbam.txt: temp/bwa_cov_check2/c_liva_exome/clamshrimp_to_clivaexome_sam.txt
	mkdir -p `dirname $@`
	-rm $@
	samtools fixmate -O bam `dirname $@`/clamshrimp_to_clivaexome_raw.sam `dirname $@`/clamshrimp_to_clivaexome_fixedbam.bam
	touch $@
temp/bwa_cov_check2/c_liva_exome/clamshrimp_to_clivaexome_sortedbam.txt: temp/bwa_cov_check2/c_liva_exome/clamshrimp_to_clivaexome_fixedbam.txt
	mkdir -p `dirname $@`
	-rm $@
	samtools sort -O bam -o `dirname $@`/clamshrimp_to_clivaexome_sortedbam.bam -T tmp/clamshrimp_to_clivaexome `dirname $@`/clamshrimp_to_clivaexome_fixedbam.bam
	touch $@
temp/bwa_cov_check2/c_liva_exome/clamshrimp_to_clivaexome_summary.txt: temp/bwa_cov_check2/c_liva_exome/clamshrimp_to_clivaexome_sortedbam.txt
	mkdir -p `dirname $@`
	-rm $@
	samtools flagstat `dirname $@`/clamshrimp_to_clivaexome_sortedbam.bam > $@
	touch $@

clamshrimp_to_human_single: temp/bwa_cov_check2/human_ref/clamshrimp_to_humrefsingle_summary.txt
temp/bwa_cov_check2/human_ref/clamshrimp_to_humrefsingle_sam.txt: temp/bwa_cov_check2/human_ref/humref_indexed.txt
	mkdir -p `dirname $@`
	-rm $@
	bwa mem -t 16 -r '@rg\tid:clamshrimp_reads\tsm:louse_ref\tlb:clamshrimp_ill' `dirname $@`/humref.fa /data1/jbrown/louse_project/raw_data/clam_shrimp/R111-L6-READ1-Sequences.txt.gz > `dirname $@`/clamshrimp_to_humrefsingle_raw.sam
	touch $@
temp/bwa_cov_check2/human_ref/clamshrimp_to_humrefsingle_fixedbam.txt: temp/bwa_cov_check2/human_ref/clamshrimp_to_humrefsingle_sam.txt
	mkdir -p `dirname $@`
	-rm $@
	samtools fixmate -O bam `dirname $@`/clamshrimp_to_humrefsingle_raw.sam `dirname $@`/clamshrimp_to_humrefsingle_fixedbam.bam
	touch $@
temp/bwa_cov_check2/human_ref/clamshrimp_to_humrefsingle_sortedbam.txt: temp/bwa_cov_check2/human_ref/clamshrimp_to_humrefsingle_fixedbam.txt
	mkdir -p `dirname $@`
	-rm $@
	samtools sort -O bam -o `dirname $@`/clamshrimp_to_humrefsingle_sortedbam.bam -T tmp/clamshrimp_to_humrefsingle `dirname $@`/clamshrimp_to_humrefsingle_fixedbam.bam
	touch $@
temp/bwa_cov_check2/human_ref/clamshrimp_to_humrefsingle_summary.txt: temp/bwa_cov_check2/human_ref/clamshrimp_to_humrefsingle_sortedbam.txt
	mkdir -p `dirname $@`
	-rm $@
	samtools flagstat `dirname $@`/clamshrimp_to_humrefsingle_sortedbam.bam > $@
	touch $@

clamshrimp_to_pedcons_single: temp/bwa_cov_check2/pediculus_blasted_contigs/clamshrimp_to_pedconssingle_summary.txt
temp/bwa_cov_check2/pediculus_blasted_contigs/clamshrimp_to_pedconssingle_sam.txt: temp/bwa_cov_check2/pediculus_blasted_contigs/pedcons_indexed.txt
	mkdir -p `dirname $@`
	-rm $@
	bwa mem -t 16 -R '@RG\tID:clamshrimp_reads\tSM:louse_ref\tLB:clamshrimp_ill' `dirname $@`/pedcons.fa /data1/jbrown/louse_project/raw_data/clam_shrimp/R111-L6-READ1-Sequences.txt.gz > `dirname $@`/clamshrimp_to_pedconssingle_raw.sam
	touch $@
temp/bwa_cov_check2/pediculus_blasted_contigs/clamshrimp_to_pedconssingle_fixedbam.txt: temp/bwa_cov_check2/pediculus_blasted_contigs/clamshrimp_to_pedconssingle_sam.txt
	mkdir -p `dirname $@`
	-rm $@
	samtools fixmate -O bam `dirname $@`/clamshrimp_to_pedconssingle_raw.sam `dirname $@`/clamshrimp_to_pedconssingle_fixedbam.bam
	touch $@
temp/bwa_cov_check2/pediculus_blasted_contigs/clamshrimp_to_pedconssingle_sortedbam.txt: temp/bwa_cov_check2/pediculus_blasted_contigs/clamshrimp_to_pedconssingle_fixedbam.txt
	mkdir -p `dirname $@`
	-rm $@
	samtools sort -O bam -o `dirname $@`/clamshrimp_to_pedconssingle_sortedbam.bam -T tmp/clamshrimp_to_pedconssingle `dirname $@`/clamshrimp_to_pedconssingle_fixedbam.bam
	touch $@
temp/bwa_cov_check2/pediculus_blasted_contigs/clamshrimp_to_pedconssingle_summary.txt: temp/bwa_cov_check2/pediculus_blasted_contigs/clamshrimp_to_pedconssingle_sortedbam.txt
	mkdir -p `dirname $@`
	-rm $@
	samtools flagstat `dirname $@`/clamshrimp_to_pedconssingle_sortedbam.bam > $@
	touch $@

clamshrimp_to_clivaexome_single: temp/bwa_cov_check2/c_liva_exome/clamshrimp_to_clivaexomesingle_summary.txt 
temp/bwa_cov_check2/c_liva_exome/clamshrimp_to_clivaexomesingle_sam.txt: temp/bwa_cov_check2/c_liva_exome/clivaexome_indexed.txt
	mkdir -p `dirname $@`
	-rm $@
	bwa mem -t 16 -R '@RG\tID:clamshrimp_reads\tSM:louse_ref\tLB:clamshrimp_ill' `dirname $@`/clivaexome.fa /data1/jbrown/louse_project/raw_data/clam_shrimp/R111-L6-READ1-Sequences.txt.gz > `dirname $@`/clamshrimp_to_clivaexomesingle_raw.sam
	touch $@
temp/bwa_cov_check2/c_liva_exome/clamshrimp_to_clivaexomesingle_fixedbam.txt: temp/bwa_cov_check2/c_liva_exome/clamshrimp_to_clivaexomesingle_sam.txt
	mkdir -p `dirname $@`
	-rm $@
	samtools fixmate -O bam `dirname $@`/clamshrimp_to_clivaexomesingle_raw.sam `dirname $@`/clamshrimp_to_clivaexomesingle_fixedbam.bam
	touch $@
temp/bwa_cov_check2/c_liva_exome/clamshrimp_to_clivaexomesingle_sortedbam.txt: temp/bwa_cov_check2/c_liva_exome/clamshrimp_to_clivaexomesingle_fixedbam.txt
	mkdir -p `dirname $@`
	-rm $@
	samtools sort -O bam -o `dirname $@`/clamshrimp_to_clivaexomesingle_sortedbam.bam -T tmp/clamshrimp_to_clivaexomesingle `dirname $@`/clamshrimp_to_clivaexomesingle_fixedbam.bam
	touch $@
temp/bwa_cov_check2/c_liva_exome/clamshrimp_to_clivaexomesingle_summary.txt: temp/bwa_cov_check2/c_liva_exome/clamshrimp_to_clivaexomesingle_sortedbam.txt
	mkdir -p `dirname $@`
	-rm $@
	samtools flagstat `dirname $@`/clamshrimp_to_clivaexomesingle_sortedbam.bam > $@
	touch $@

################################################################################
################################################################################

diamond_180bp: temp/megan/diamond_blast_180bp_to_nr_R1.txt temp/megan/diamond_blast_180bp_to_nr_R2.txt temp/megan/diamond_blast_180bp_to_nr_R1_rma.txt temp/megan/diamond_blast_180bp_to_nr_R2_rma.txt
temp/megan/diamond_nr_database_made.txt:
	mkdir -p `dirname $@`
	-rm $@
	diamond makedb -p 16 --in raw_data/nr/nr -d `dirname $@`/nr
	touch $@
temp/megan/diamond_blast_180bp_to_nr_R1_daa.txt: temp/megan/diamond_nr_database_made.txt
	mkdir -p `dirname $@`
	-rm $@
	diamond blastx -p 16 -d `dirname $@`/nr -q raw_data/louse_from_mike_dir/duplicates_removed/columbicola_180_seqyclean_PE1.fastq.gz -a `dirname $@`/180bp_to_nr_R1 -t tmp
	touch $@
temp/megan/diamond_blast_180bp_to_nr_R2_daa.txt: temp/megan/diamond_nr_database_made.txt
	mkdir -p `dirname $@`
	-rm $@
	diamond blastx -p 16 -d `dirname $@`/nr -q raw_data/louse_from_mike_dir/duplicates_removed/columbicola_180_seqyclean_PE2.fastq.gz -a `dirname $@`/180bp_to_nr_R2 -t tmp
	touch $@
temp/megan/diamond_blast_180bp_to_nr_R1.txt: temp/megan/diamond_blast_180bp_to_nr_R1_daa.txt
	mkdir -p `dirname $@`
	-rm $@
	diamond view -p 16 -a `dirname $@`/180bp_to_nr_R1.daa -o `dirname $@`/180bp_to_nr_R1.m8
	touch $@
temp/megan/diamond_blast_180bp_to_nr_R2.txt: temp/megan/diamond_blast_180bp_to_nr_R2_daa.txt
	mkdir -p `dirname $@`
	-rm $@
	diamond view -p 16 -a `dirname $@`/180bp_to_nr_R2.daa -o `dirname $@`/180bp_to_nr_R2.m8
	touch $@
temp/megan/diamond_blast_180bp_to_nr_R1_rma.txt: temp/megan/diamond_blast_180bp_to_nr_R1_daa.txt raw_data/nr/megan_tax_files.txt
	mkdir -p `dirname $@`
	-rm $@
	daa2rma -i `dirname $@`/180bp_to_nr_R1.daa -o `dirname $@`/180bp_to_nr_R1.rma6 -a2t raw_data/nr/prot_acc2tax-Nov2016.abin
	touch $@
temp/megan/diamond_blast_180bp_to_nr_R2_rma.txt: temp/megan/diamond_blast_180bp_to_nr_R2_daa.txt raw_data/nr/megan_tax_files.txt
	mkdir -p `dirname $@`
	-rm $@
	daa2rma -i `dirname $@`/180bp_to_nr_R2.daa -o `dirname $@`/180bp_to_nr_R2.rma6 -a2t raw_data/nr/prot_acc2tax-Nov2016.abin
	touch $@

diamond_second_srr: temp/megan/diamond_blast_second_srr_to_nr_R1.txt temp/megan/diamond_blast_second_srr_to_nr_R1_rma.txt
temp/megan/diamond_blast_second_srr_to_nr_R1_daa.txt: temp/megan/diamond_nr_database_made.txt
	mkdir -p `dirname $@`
	-rm $@
	diamond blastx -p 16 -d `dirname $@`/nr -q raw_data/louse_data_sra/second_srr_from_bioproject/SRR3161917.fastq -a `dirname $@`/second_srr_to_nr_R1 -t tmp
	touch $@
temp/megan/diamond_blast_second_srr_to_nr_R1.txt: temp/megan/diamond_blast_second_srr_to_nr_R1_daa.txt
	mkdir -p `dirname $@`
	-rm $@
	diamond view -p 16 -a `dirname $@`/second_srr_to_nr_R1.daa -o `dirname $@`/second_srr_to_nr_R1.m8
	touch $@
temp/megan/diamond_blast_second_srr_to_nr_R1_rma.txt: temp/megan/diamond_blast_second_srr_to_nr_R1_daa.txt raw_data/nr/megan_tax_files.txt
	mkdir -p `dirname $@`
	-rm $@
	daa2rma -i `dirname $@`/second_srr_to_nr_R1.daa -o `dirname $@`/second_srr_to_nr_R1.rma6 -a2t raw_data/nr/prot_acc2tax-Nov2016.abin
	touch $@


diamond_clamshrimp: temp/megan/diamond_blast_clamshrimp_to_nr_R1.txt temp/megan/diamond_blast_clamshrimp_to_nr_R2.txt temp/megan/diamond_blast_clamshrimp_to_nr_R1_rma.txt temp/megan/diamond_blast_clamshrimp_to_nr_R2_rma.txt
#/data1/jbrown/louse_project/raw_data/clam_shrimp/R111-L6-READ1-Sequences.txt.gz
temp/megan/diamond_blast_clamshrimp_to_nr_R1_daa.txt: temp/megan/diamond_nr_database_made.txt
	mkdir -p `dirname $@`
	-rm $@
	diamond blastx -p 16 -d `dirname $@`/nr -q /data1/jbrown/louse_project/raw_data/clam_shrimp/R111-L6-READ1-Sequences.txt.gz -a `dirname $@`/clamshrimp_to_nr_R1 -t tmp
	touch $@
temp/megan/diamond_blast_clamshrimp_to_nr_R2_daa.txt: temp/megan/diamond_nr_database_made.txt
	mkdir -p `dirname $@`
	-rm $@
	diamond blastx -p 16 -d `dirname $@`/nr -q /data1/jbrown/louse_project/raw_data/clam_shrimp/R111-L6-READ2-Sequences.txt.gz -a `dirname $@`/clamshrimp_to_nr_R2 -t tmp
	touch $@
temp/megan/diamond_blast_clamshrimp_to_nr_R1.txt: temp/megan/diamond_blast_clamshrimp_to_nr_R1_daa.txt
	mkdir -p `dirname $@`
	-rm $@
	diamond view -p 16 -a `dirname $@`/clamshrimp_to_nr_R1.daa -o `dirname $@`/clamshrimp_to_nr_R1.m8
	touch $@
temp/megan/diamond_blast_clamshrimp_to_nr_R2.txt: temp/megan/diamond_blast_clamshrimp_to_nr_R2_daa.txt
	mkdir -p `dirname $@`
	-rm $@
	diamond view -p 16 -a `dirname $@`/clamshrimp_to_nr_R2.daa -o `dirname $@`/clamshrimp_to_nr_R2.m8
	touch $@
temp/megan/diamond_blast_clamshrimp_to_nr_R1_rma.txt: temp/megan/diamond_blast_clamshrimp_to_nr_R1_daa.txt raw_data/nr/megan_tax_files.txt
	mkdir -p `dirname $@`
	-rm $@
	daa2rma -i `dirname $@`/clamshrimp_to_nr_R1.daa -o `dirname $@`/clamshrimp_to_nr_R1.rma6 -a2t raw_data/nr/prot_acc2tax-Nov2016.abin
	touch $@
temp/megan/diamond_blast_clamshrimp_to_nr_R2_rma.txt: temp/megan/diamond_blast_clamshrimp_to_nr_R2_daa.txt raw_data/nr/megan_tax_files.txt
	mkdir -p `dirname $@`
	-rm $@
	daa2rma -i `dirname $@`/clamshrimp_to_nr_R2.daa -o `dirname $@`/clamshrimp_to_nr_R2.rma6 -a2t raw_data/nr/prot_acc2tax-Nov2016.abin
	touch $@

megan_tax_files: raw_data/nr/megan_tax_files.txt
raw_data/nr/megan_tax_files.txt:
	mkdir -p `dirname $@`
	-rm $@
	cd `dirname $@` && make
	touch $@

diamond_anna_assembly: temp/megan/diamond_blast_anna_assembly_to_nr_R1.txt temp/megan/diamond_blast_anna_assembly_to_nr_R1_rma.txt
temp/megan/diamond_blast_anna_assembly_to_nr_R1_daa.txt: temp/megan/diamond_nr_database_made.txt
	mkdir -p `dirname $@`
	-rm $@
	diamond blastx -p 16 -d `dirname $@`/nr -q raw_data/previous_assemblies/taxon_filtered_louse/ALM_F2Male_MDS349_CLCassembly.fasta -a `dirname $@`/anna_assembly_to_nr_R1 -t tmp
	touch $@
temp/megan/diamond_blast_anna_assembly_to_nr_R1.txt: temp/megan/diamond_blast_anna_assembly_to_nr_R1_daa.txt
	mkdir -p `dirname $@`
	-rm $@
	diamond view -p 16 -a `dirname $@`/anna_assembly_to_nr_R1.daa -o `dirname $@`/anna_assembly_to_nr_R1.m8
	touch $@
temp/megan/diamond_blast_anna_assembly_to_nr_R1_rma.txt: temp/megan/diamond_blast_anna_assembly_to_nr_R1_daa.txt raw_data/nr/megan_tax_files.txt
	mkdir -p `dirname $@`
	-rm $@
	daa2rma -i `dirname $@`/anna_assembly_to_nr_R1.daa -o `dirname $@`/anna_assembly_to_nr_R1.rma6 -a2t raw_data/nr/prot_acc2tax-Nov2016.abin
	touch $@

################################################################################
################################################################################

#bwa/gatk to find snp frequency of inbred and outbred data using only pedcons-aligned data:

##filter anna's assembly to only get pediculus blasted contigs (according to diamond):
#
#temp/bwa_gatk/anna_assembly_pedcons2_ref/m8_filtered.txt: scripts/megan/filter_by_taxid.py temp/megan/diamond_blast_anna_assembly_to_nr_R1.txt raw_data/nr/prot.accession2taxid
#	mkdir -p `dirname $@`
#	-rm $@
#	python $< temp/megan/anna_assembly_to_nr_R1.m8 raw_data/nr/prot.accession2taxid 121224 > $@
#	touch $@
#
#temp/bwa_gatk/anna_assembly_pedcons2_ref

#use megan-filtered file for bwa/gatk:

bwa_gatk_outbred2: temp/bwa_gatk/anna_assembly_outbred_pedcons2/all_done.txt
temp/bwa_gatk/anna_assembly_outbred_pedcons2/copied_scripts.txt: scripts/bwa_gatk/anna_assembly_outbred_pedcons2/Makefile scripts/bwa_gatk/anna_assembly_outbred_pedcons2/snptable_8sigfig.pl
	mkdir -p `dirname $@`
	-rm $@
	rsync -avP `dirname $<` `dirname $@` --files-from <(cd scripts/bwa_gatk/anna_assembly_outbred_pedcons2 && find . -type f -maxdepth 1 -mindepth 0 | sort)
	touch $@
temp/bwa_gatk/anna_assembly_outbred_pedcons2/all_done.txt: temp/bwa_gatk/anna_assembly_outbred_pedcons2/copied_scripts.txt
	-rm $@
	cd `dirname $@` && make -k -j
	touch $@
af_bwa_outbred2: temp/bwa_gatk/anna_assembly_outbred_pedcons2/data/snp_tables/only-PASS-Q30-SNPs_split_poly.txt temp/bwa_gatk/anna_assembly_outbred_pedcons2/data/snp_tables/only-PASS-Q30-SNPs_split_poly_hetcalc_avg_het.txt temp/bwa_gatk/anna_assembly_outbred_pedcons2/data/snp_tables/only-PASS-Q30-SNPs_split_poly_plotted.pdf plots/bwa_gatk/anna_assembly_outbred_pedcons2/data/snp_tables/only-PASS-Q30-SNPs_split_poly_plotted.pdf plots/bwa_gatk/anna_assembly_outbred_pedcons2/data/snp_tables/only-PASS-Q30-INDEL_split_poly_plotted.pdf temp/bwa_gatk/anna_assembly_outbred_pedcons2/data/snp_tables/only-PASS-Q30-INDEL_split_poly_hetcalc_avg_het.txt
temp/bwa_gatk/anna_assembly_outbred_pedcons2/data/snp_tables/only-PASS-Q30-SNPs_split_poly.txt: scripts/allele_freq/allele_split.py temp/bwa_gatk/anna_assembly_outbred_pedcons2/all_done.txt
	-rm $@
	python $< temp/bwa_gatk/anna_assembly_outbred_pedcons2/data/snp_tables/only-PASS-Q30-SNPs.txt `dirname $@`/`basename $@ _poly.txt`
temp/bwa_gatk/anna_assembly_outbred_pedcons2/data/snp_tables/only-PASS-Q30-SNPs_split_poly_hetcalc_avg_het.txt: scripts/allele_freq/calc_heterozygosity.py temp/bwa_gatk/anna_assembly_outbred_pedcons2/data/snp_tables/only-PASS-Q30-SNPs_split_poly.txt
	-rm $@
	python $^ `dirname $@`/`basename $@ _avg_het.txt` 35235095
temp/bwa_gatk/anna_assembly_outbred_pedcons2/data/snp_tables/only-PASS-Q30-SNPs_split_poly_plotted.pdf: scripts/allele_freq/plot_af.R temp/bwa_gatk/anna_assembly_outbred_pedcons2/data/snp_tables/only-PASS-Q30-SNPs_split_poly.txt
	-rm $@
	Rscript $^ $@
plots/bwa_gatk/anna_assembly_outbred_pedcons2/data/snp_tables/only-PASS-Q30-SNPs_split_poly_plotted.pdf: temp/bwa_gatk/anna_assembly_outbred_pedcons2/data/snp_tables/only-PASS-Q30-SNPs_split_poly_plotted.pdf
	mkdir -p `dirname $@`
	-rm $@
	rsync -avP $< $@
temp/bwa_gatk/anna_assembly_outbred_pedcons2/data/snp_tables/only-PASS-Q30-INDEL_split_poly.txt: scripts/allele_freq/allele_split.py temp/bwa_gatk/anna_assembly_outbred_pedcons2/all_done.txt
	-rm $@
	python $< temp/bwa_gatk/anna_assembly_outbred_pedcons2/data/snp_tables/only-PASS-Q30-INDEL.txt `dirname $@`/`basename $@ _poly.txt`
temp/bwa_gatk/anna_assembly_outbred_pedcons2/data/snp_tables/only-PASS-Q30-INDEL_split_poly_hetcalc_avg_het.txt: scripts/allele_freq/calc_heterozygosity.py temp/bwa_gatk/anna_assembly_outbred_pedcons2/data/snp_tables/only-PASS-Q30-INDEL_split_poly.txt
	-rm $@
	python $^ `dirname $@`/`basename $@ _avg_het.txt` 35235095
temp/bwa_gatk/anna_assembly_outbred_pedcons2/data/snp_tables/only-PASS-Q30-INDEL_split_poly_plotted.pdf: scripts/allele_freq/plot_af.R temp/bwa_gatk/anna_assembly_outbred_pedcons2/data/snp_tables/only-PASS-Q30-INDEL_split_poly.txt
	-rm $@
	Rscript $^ $@
plots/bwa_gatk/anna_assembly_outbred_pedcons2/data/snp_tables/only-PASS-Q30-INDEL_split_poly_plotted.pdf: temp/bwa_gatk/anna_assembly_outbred_pedcons2/data/snp_tables/only-PASS-Q30-INDEL_split_poly_plotted.pdf
	mkdir -p `dirname $@`
	-rm $@
	rsync -avP $< $@

bwa_gatk_inbred2: temp/bwa_gatk/anna_assembly_inbred_pedcons2/all_done.txt
temp/bwa_gatk/anna_assembly_inbred_pedcons2/copied_scripts.txt: scripts/bwa_gatk/anna_assembly_inbred_pedcons2/Makefile scripts/bwa_gatk/anna_assembly_inbred_pedcons2/snptable_8sigfig.pl
	mkdir -p `dirname $@`
	-rm $@
	rsync -avP `dirname $<` `dirname $@` --files-from <(cd scripts/bwa_gatk/anna_assembly_inbred_pedcons2 && find . -type f -maxdepth 1 -mindepth 0 | sort)
temp/bwa_gatk/anna_assembly_inbred_pedcons2/all_done.txt: temp/bwa_gatk/anna_assembly_inbred_pedcons2/copied_scripts.txt
	-rm $@
	cd `dirname $@` && make -k -j
af_bwa_inbred2: temp/bwa_gatk/anna_assembly_inbred_pedcons2/data/snp_tables/only-PASS-Q30-SNPs_split_poly.txt temp/bwa_gatk/anna_assembly_inbred_pedcons2/data/snp_tables/only-PASS-Q30-SNPs_split_poly_hetcalc_avg_het.txt temp/bwa_gatk/anna_assembly_inbred_pedcons2/data/snp_tables/only-PASS-Q30-SNPs_split_poly_plotted.pdf plots/bwa_gatk/anna_assembly_inbred_pedcons2/data/snp_tables/only-PASS-Q30-SNPs_split_poly_plotted.pdf temp/bwa_gatk/anna_assembly_inbred_pedcons2/data/snp_tables/only-PASS-Q30-INDEL_split_poly_hetcalc_avg_het.txt plots/bwa_gatk/anna_assembly_inbred_pedcons2/data/snp_tables/only-PASS-Q30-INDEL_split_poly_plotted.pdf
temp/bwa_gatk/anna_assembly_inbred_pedcons2/data/snp_tables/only-PASS-Q30-SNPs_split_poly.txt: scripts/allele_freq/allele_split.py temp/bwa_gatk/anna_assembly_inbred_pedcons2/all_done.txt
	-rm $@
	python $< temp/bwa_gatk/anna_assembly_inbred_pedcons2/data/snp_tables/only-PASS-Q30-SNPs.txt `dirname $@`/`basename $@ _poly.txt`
temp/bwa_gatk/anna_assembly_inbred_pedcons2/data/snp_tables/only-PASS-Q30-SNPs_split_poly_hetcalc_avg_het.txt: scripts/allele_freq/calc_heterozygosity.py temp/bwa_gatk/anna_assembly_inbred_pedcons2/data/snp_tables/only-PASS-Q30-SNPs_split_poly.txt
	-rm $@
	python $^ `dirname $@`/`basename $@ _avg_het.txt` 35235095
temp/bwa_gatk/anna_assembly_inbred_pedcons2/data/snp_tables/only-PASS-Q30-SNPs_split_poly_plotted.pdf: scripts/allele_freq/plot_af.R temp/bwa_gatk/anna_assembly_inbred_pedcons2/data/snp_tables/only-PASS-Q30-SNPs_split_poly.txt
	-rm $@
	Rscript $^ $@
plots/bwa_gatk/anna_assembly_inbred_pedcons2/data/snp_tables/only-PASS-Q30-SNPs_split_poly_plotted.pdf: temp/bwa_gatk/anna_assembly_inbred_pedcons2/data/snp_tables/only-PASS-Q30-SNPs_split_poly_plotted.pdf
	mkdir -p `dirname $@`
	-rm $@
	rsync -avP $< $@
temp/bwa_gatk/anna_assembly_inbred_pedcons2/data/snp_tables/only-PASS-Q30-INDEL_split_poly.txt: scripts/allele_freq/allele_split.py temp/bwa_gatk/anna_assembly_inbred_pedcons2/all_done.txt
	-rm $@
	python $< temp/bwa_gatk/anna_assembly_inbred_pedcons2/data/snp_tables/only-PASS-Q30-INDEL.txt `dirname $@`/`basename $@ _poly.txt`
temp/bwa_gatk/anna_assembly_inbred_pedcons2/data/snp_tables/only-PASS-Q30-INDEL_split_poly_hetcalc_avg_het.txt: scripts/allele_freq/calc_heterozygosity.py temp/bwa_gatk/anna_assembly_inbred_pedcons2/data/snp_tables/only-PASS-Q30-INDEL_split_poly.txt
	-rm $@
	python $^ `dirname $@`/`basename $@ _avg_het.txt` 35235095
temp/bwa_gatk/anna_assembly_inbred_pedcons2/data/snp_tables/only-PASS-Q30-INDEL_split_poly_plotted.pdf: scripts/allele_freq/plot_af.R temp/bwa_gatk/anna_assembly_inbred_pedcons2/data/snp_tables/only-PASS-Q30-INDEL_split_poly.txt
	-rm $@
	Rscript $^ $@
plots/bwa_gatk/anna_assembly_inbred_pedcons2/data/snp_tables/only-PASS-Q30-INDEL_split_poly_plotted.pdf: temp/bwa_gatk/anna_assembly_inbred_pedcons2/data/snp_tables/only-PASS-Q30-INDEL_split_poly_plotted.pdf
	mkdir -p `dirname $@`
	-rm $@
	rsync -avP $< $@

#inbred and outbred snp allele freq histo for poster:
plot_af_io: temp/bwa_gatk/anna_assembly_inbred_pedcons2/data/snp_tables/only-PASS-Q30-SNPs_split_poly_plotted_inbredoutbred.pdf plots/bwa_gatk/anna_assembly_inbred_pedcons2/data/snp_tables/only-PASS-Q30-SNPs_split_poly_plotted_inbredoutbred.pdf
temp/bwa_gatk/anna_assembly_inbred_pedcons2/data/snp_tables/only-PASS-Q30-SNPs_split_poly_plotted_inbredoutbred.pdf: scripts/allele_freq/plot_af_inbredoutbred.R temp/bwa_gatk/anna_assembly_inbred_pedcons2/data/snp_tables/only-PASS-Q30-SNPs_split_poly.txt temp/bwa_gatk/anna_assembly_outbred_pedcons2/data/snp_tables/only-PASS-Q30-SNPs_split_poly.txt
	-rm $@
	Rscript $^ $@
plots/bwa_gatk/anna_assembly_inbred_pedcons2/data/snp_tables/only-PASS-Q30-SNPs_split_poly_plotted_inbredoutbred.pdf: temp/bwa_gatk/anna_assembly_inbred_pedcons2/data/snp_tables/only-PASS-Q30-SNPs_split_poly_plotted_inbredoutbred.pdf
	mkdir -p `dirname $@`
	-rm $@
	rsync -avP $< $@


################################################################################
################################################################################

#test chris' quality scores:
minion_qual_test: minion_qual_test_anna minion_qual_test_chris
minion_qual_test_chris: temp/minion_test/chris_quals_mean.txt temp/minion_test/chris_quals_hist.pdf temp/minion_test/chris_lens_mean.txt temp/minion_test/chris_lens_hist.pdf temp/minion_test/chris_lenqual_plot.pdf temp/minion_test/chris_read_count.txt temp/minion_test/chris_bp_count.txt
temp/minion_test/chris_quals.txt: scripts/util/calculate_average_read_quality.py raw_data/sample_minion/DpseST_ON1.fastq
	mkdir -p `dirname $@`
	-rm $@
	python $^ > $@
	touch $@
temp/minion_test/chris_quals_mean.txt: scripts/util/mean temp/minion_test/chris_quals.txt
	mkdir -p `dirname $@`
	-rm $@
	python $^ > $@
	touch $@
temp/minion_test/chris_quals_hist.pdf: scripts/util/hist temp/minion_test/chris_quals.txt
	mkdir -p `dirname $@`
	-rm $@
	Rscript $^ $@
	touch $@
temp/minion_test/chris_lens.txt: scripts/util/read_lengths.py raw_data/sample_minion/DpseST_ON1.fastq
	mkdir -p `dirname $@`
	-rm $@
	python $^ > $@
	touch $@
temp/minion_test/chris_lens_mean.txt: scripts/util/mean temp/minion_test/chris_lens.txt
	mkdir -p `dirname $@`
	-rm $@
	python $^ > $@
	touch $@
temp/minion_test/chris_lens_hist.pdf: scripts/util/hist temp/minion_test/chris_lens.txt
	mkdir -p `dirname $@`
	-rm $@
	Rscript $^ $@
	touch $@
temp/minion_test/chris_lenqual_plot.pdf: scripts/util/xyplot temp/minion_test/chris_lens.txt temp/minion_test/chris_quals.txt
	mkdir -p `dirname $@`
	-rm $@
	Rscript $^ $@
	touch $@
temp/minion_test/chris_read_count.txt: raw_data/sample_minion/DpseST_ON1.fastq
	mkdir -p `dirname $@`
	-rm $@
	cat $< | awk 'NR%4==2' | wc -l > $@
	touch $@
temp/minion_test/chris_bp_count.txt: raw_data/sample_minion/DpseST_ON1.fastq
	mkdir -p `dirname $@`
	-rm $@
	cat $< | awk 'NR%4==2' | tr -d '\n' | wc -c > $@
	touch $@

minion_qual_test_anna: temp/minion_test/anna_quals_mean.txt temp/minion_test/anna_quals_hist.pdf temp/minion_test/anna_lens_mean.txt temp/minion_test/anna_lens_hist.pdf temp/minion_test/anna_lenqual_plot.pdf temp/minion_test/anna_read_count.txt temp/minion_test/anna_bp_count.txt
temp/minion_test/anna_quals.txt: scripts/util/calculate_average_read_quality.py raw_data/louse_data_from_anna/minION_seq_mar2016/louse_fastq/louse_all.fq
	mkdir -p `dirname $@`
	-rm $@
	python $^ > $@
	touch $@
temp/minion_test/anna_quals_mean.txt: scripts/util/mean temp/minion_test/anna_quals.txt
	mkdir -p `dirname $@`
	-rm $@
	python $^ > $@
	touch $@
temp/minion_test/anna_quals_hist.pdf: scripts/util/hist temp/minion_test/anna_quals.txt
	mkdir -p `dirname $@`
	-rm $@
	Rscript $^ $@
	touch $@
temp/minion_test/anna_lens.txt: scripts/util/read_lengths.py raw_data/louse_data_from_anna/minION_seq_mar2016/louse_fastq/louse_all.fq
	mkdir -p `dirname $@`
	-rm $@
	python $^ > $@
	touch $@
temp/minion_test/anna_lens_mean.txt: scripts/util/mean temp/minion_test/anna_lens.txt
	mkdir -p `dirname $@`
	-rm $@
	python $^ > $@
	touch $@
temp/minion_test/anna_lens_hist.pdf: scripts/util/hist temp/minion_test/anna_lens.txt
	mkdir -p `dirname $@`
	-rm $@
	Rscript $^ $@
	touch $@
temp/minion_test/anna_lenqual_plot.pdf: scripts/util/xyplot temp/minion_test/anna_lens.txt temp/minion_test/anna_quals.txt
	mkdir -p `dirname $@`
	-rm $@
	Rscript $^ $@
	touch $@
temp/minion_test/anna_read_count.txt: raw_data/louse_data_from_anna/minION_seq_mar2016/louse_fastq/louse_all.fq
	mkdir -p `dirname $@`
	-rm $@
	cat $< | awk 'NR%4==2' | wc -l > $@
	touch $@
temp/minion_test/anna_bp_count.txt: raw_data/louse_data_from_anna/minION_seq_mar2016/louse_fastq/louse_all.fq
	mkdir -p `dirname $@`
	-rm $@
	cat $< | awk 'NR%4==2' | tr -d '\n' | wc -c > $@
	touch $@

minion_qual_test_tom: temp/minion_test/tom_quals_mean.txt temp/minion_test/tom_quals_hist.pdf temp/minion_test/tom_lens_mean.txt temp/minion_test/tom_lens_hist.pdf temp/minion_test/tom_lenqual_plot.pdf temp/minion_test/tom_read_count.txt temp/minion_test/tom_bp_count.txt temp/minion_test/tom_quals_hist2.pdf
temp/minion_test/tom_quals.txt: scripts/util/calculate_average_read_quality.py raw_data/sample_minion/tom_sasani/nanopore-data-jim/FAF03020.combined.fastq
	mkdir -p `dirname $@`
	-rm $@
	python $^ > $@
	touch $@
temp/minion_test/tom_quals_mean.txt: scripts/util/mean temp/minion_test/tom_quals.txt
	mkdir -p `dirname $@`
	-rm $@
	python $^ > $@
	touch $@
temp/minion_test/tom_quals_hist.pdf: scripts/util/hist temp/minion_test/tom_quals.txt
	mkdir -p `dirname $@`
	-rm $@
	Rscript $^ $@
	touch $@
temp/minion_test/tom_lens.txt: scripts/util/read_lengths.py raw_data/sample_minion/tom_sasani/nanopore-data-jim/FAF03020.combined.fastq
	mkdir -p `dirname $@`
	-rm $@
	python $^ > $@
	touch $@
temp/minion_test/tom_lens_mean.txt: scripts/util/mean temp/minion_test/tom_lens.txt
	mkdir -p `dirname $@`
	-rm $@
	python $^ > $@
	touch $@
temp/minion_test/tom_lens_hist.pdf: scripts/util/hist temp/minion_test/tom_lens.txt
	mkdir -p `dirname $@`
	-rm $@
	Rscript $^ $@
	touch $@
temp/minion_test/tom_lenqual_plot.pdf: scripts/util/xyplot temp/minion_test/tom_lens.txt temp/minion_test/tom_quals.txt
	mkdir -p `dirname $@`
	-rm $@
	Rscript $^ $@
	touch $@
temp/minion_test/tom_read_count.txt: raw_data/sample_minion/tom_sasani/nanopore-data-jim/FAF03020.combined.fastq
	mkdir -p `dirname $@`
	-rm $@
	cat $< | awk 'NR%4==2' | wc -l > $@
	touch $@
temp/minion_test/tom_bp_count.txt: raw_data/sample_minion/tom_sasani/nanopore-data-jim/FAF03020.combined.fastq
	mkdir -p `dirname $@`
	-rm $@
	cat $< | awk 'NR%4==2' | tr -d '\n' | wc -c > $@
	touch $@
temp/minion_test/tom_quals_hist2.pdf: scripts/util/fq_qual_hist temp/minion_test/tom_quals.txt
	mkdir -p `dirname $@`
	-rm $@
	Rscript $^ $@
	touch $@

#do plotting and summary stat calculations for sample pacbio and minion data (publicly available):
minion_qual_test_pacbiosample: temp/minion_test/pacbiosample_quals_mean.txt temp/minion_test/pacbiosample_quals_hist.pdf temp/minion_test/pacbiosample_lens_hist.pdf temp/minion_test/pacbiosample_lens_hist2.pdf
temp/minion_test/pacbiosample_quals.txt: scripts/util/calculate_average_read_quality.py raw_data/sample_minion/from_human/pacbio/downloads.pacbcloud.com/public/SequelData/ArabidopsisDemoData/SequenceData/1_A01_customer/m54113_160913_184949.subreads.bam.fq
	mkdir -p `dirname $@`
	-rm $@
	python $^ > $@
	touch $@
temp/minion_test/pacbiosample_quals_mean.txt: scripts/util/mean temp/minion_test/pacbiosample_quals.txt
	mkdir -p `dirname $@`
	-rm $@
	python $^ > $@
	touch $@
temp/minion_test/pacbiosample_quals_hist.pdf: scripts/util/hist temp/minion_test/pacbiosample_quals.txt
	mkdir -p `dirname $@`
	-rm $@
	Rscript $^ $@
	touch $@
temp/minion_test/pacbiosample_lens.txt: scripts/util/read_lengths.py raw_data/sample_minion/from_human/pacbio/downloads.pacbcloud.com/public/SequelData/ArabidopsisDemoData/SequenceData/1_A01_customer/m54113_160913_184949.subreads.bam.fq
	mkdir -p `dirname $@`
	-rm $@
	python $^ > $@
	touch $@
temp/minion_test/pacbiosample_lens_hist.pdf: scripts/util/hist temp/minion_test/pacbiosample_lens.txt
	mkdir -p `dirname $@`
	-rm $@
	Rscript $^ $@
	touch $@
temp/minion_test/pacbiosample_stats.txt: scripts/util/fqstatsqual.py raw_data/sample_minion/from_human/pacbio/downloads.pacbcloud.com/public/SequelData/ArabidopsisDemoData/SequenceData/1_A01_customer/m54113_160913_184949.subreads.bam.fq
	mkdir -p `dirname $@`
	-rm $@
	python $^ > $@
temp/minion_test/pacbiosample_lens_hist2.pdf: scripts/util/fq_read_hist temp/minion_test/pacbiosample_lens.txt
	mkdir -p `dirname $@`
	-rm $@
	Rscript $^ $@
	touch $@

minion_qual_test_minion94sample: temp/minion_test/minion94sample_quals_mean.txt temp/minion_test/minion94sample_quals_hist.pdf temp/minion_test/minion94sample_lens_hist.pdf temp/minion_test/minion94sample_lens_hist2.pdf
temp/minion_test/minion94sample_quals.txt: scripts/util/calculate_average_read_quality.py raw_data/sample_minion/from_human/rel2-nanopore-wgs-4246400039-FAB39075.fastq
	mkdir -p `dirname $@`
	-rm $@
	python $^ > $@
	touch $@
temp/minion_test/minion94sample_quals_mean.txt: scripts/util/mean temp/minion_test/minion94sample_quals.txt
	mkdir -p `dirname $@`
	-rm $@
	python $^ > $@
	touch $@
temp/minion_test/minion94sample_quals_hist.pdf: scripts/util/hist temp/minion_test/minion94sample_quals.txt
	mkdir -p `dirname $@`
	-rm $@
	Rscript $^ $@
	touch $@
temp/minion_test/minion94sample_lens.txt: scripts/util/read_lengths.py raw_data/sample_minion/from_human/rel2-nanopore-wgs-4246400039-FAB39075.fastq
	mkdir -p `dirname $@`
	-rm $@
	python $^ > $@
	touch $@
temp/minion_test/minion94sample_lens_hist.pdf: scripts/util/hist temp/minion_test/minion94sample_lens.txt
	mkdir -p `dirname $@`
	-rm $@
	Rscript $^ $@
	touch $@
temp/minion_test/minion94sample_stats.txt: scripts/util/fqstatsqual.py raw_data/sample_minion/from_human/rel2-nanopore-wgs-4246400039-FAB39075.fastq
	mkdir -p `dirname $@`
	-rm $@
	python $^ > $@
temp/minion_test/minion94sample_lens_hist2.pdf: scripts/util/fq_read_hist temp/minion_test/minion94sample_lens.txt
	mkdir -p `dirname $@`
	-rm $@
	Rscript $^ $@
	touch $@

################################################################################
################################################################################

#quality histogram from chakraborty 2016 pacbio data:

pbchak_hist: temp/minion_test/pbchak_quals_hist.pdf
temp/minion_test/pbchak_quals_hist.pdf: scripts/util/fq_qual_hist_pbchak /data1/jbrown/louse_project/raw_data/sample_minion/PacBio/from_chak/empirical_quality_data.txt
	mkdir -p `dirname $@`
	-rm $@
	Rscript $^ $@
	touch $@

################################################################################
################################################################################

#run repeatmasker on the CLC (anna's) assembly:
clc_repmask: temp/repeatmasker/clc/clc_repeatmasker_done.txt
temp/repeatmasker/clc/clc_repmask_database_done.txt: raw_data/previous_assemblies/taxon_filtered_louse/ALM_F2Male_MDS349_CLCassembly.fasta
	mkdir -p `dirname $@`
	-rm $@
	rsync -avP $< `dirname $@`
	cd `dirname $@` && BuildDatabase -name louse_clc `basename $<`
	touch $@
temp/repeatmasker/clc/clc_repmodeler_done.txt: temp/repeatmasker/clc/clc_repmask_database_done.txt
	mkdir -p `dirname $@`
	mkdir -p `dirname $@`/lib
	-rm $@
	cd `dirname $@` && RepeatModeler -pa 32 -database louse_clc >& repeatmodeler_out.txt
	mv `dirname $@`/RM_*/consensi* `dirname $@`/lib
	rm -r `dirname $@`/RM_*
	touch $@
temp/repeatmasker/clc/clc_repeatmasker_done.txt: raw_data/previous_assemblies/taxon_filtered_louse/ALM_F2Male_MDS349_CLCassembly.fasta temp/repeatmasker/clc/clc_repmodeler_done.txt
	mkdir -p `dirname $@`
	-rm $@
	cd `dirname $@` && RepeatMasker $< -lib lib/consensi.fa.classified -gff -pa 32
	touch $@

#run repeatmasker on the portion of the CLC (anna's) assembly that blasts to pediculus:
pedcons_repmask: temp/repeatmasker/pedcons/pedcons_repeatmasker_done.txt
temp/repeatmasker/pedcons/pedcons_repmask_database_done.txt: temp/megan/anna_assembly_to_nr_R1-ex.fasta
	mkdir -p `dirname $@`
	-rm $@
	rsync -avP $< `dirname $@`
	cd `dirname $@` && BuildDatabase -name louse_pedcons `basename $<`
	touch $@
temp/repeatmasker/pedcons/pedcons_repmodeler_done.txt: temp/repeatmasker/pedcons/pedcons_repmask_database_done.txt
	mkdir -p `dirname $@`
	mkdir -p `dirname $@`/lib
	-rm $@
	cd `dirname $@` && RepeatModeler -pa 32 -database louse_pedcons >& repeatmodeler_out.txt
	mv `dirname $@`/RM_*/consensi* `dirname $@`/lib
	rm -r `dirname $@`/RM_*
	touch $@
temp/repeatmasker/pedcons/pedcons_repeatmasker_done.txt: temp/repeatmasker/pedcons/anna_assembly_to_nr_R1-ex.fasta temp/repeatmasker/pedcons/pedcons_repmodeler_done.txt
	mkdir -p `dirname $@`
	-rm $@
	cd `dirname $@` && RepeatMasker `basename $<` -lib lib/consensi.fa.classified -gff -pa 32
	touch $@


#run repeatmasker on the unscaffolded final canu v2 contigs:
canu2_repmask: temp/repeatmasker/canu2/canu2_repeatmasker_done.txt
temp/repeatmasker/canu2/canu2_repmask_database_done.txt: temp/pilon/v1/piloned.fasta
	mkdir -p `dirname $@`
	-rm $@
	rsync -avP $< `dirname $@`
	cd `dirname $@` && BuildDatabase -name louse_canu2 `basename $<`
	touch $@
temp/repeatmasker/canu2/canu2_repmodeler_done.txt: temp/repeatmasker/canu2/canu2_repmask_database_done.txt
	mkdir -p `dirname $@`
	mkdir -p `dirname $@`/lib
	-rm $@
	cd `dirname $@` && RepeatModeler -pa 32 -database louse_canu2 >& repeatmodeler_out.txt
	mv `dirname $@`/RM_*/consensi* `dirname $@`/lib
	rm -r `dirname $@`/RM_*
	touch $@
temp/repeatmasker/canu2/canu2_repeatmasker_done.txt: temp/pilon/v1/piloned.fasta temp/repeatmasker/canu2/canu2_repmodeler_done.txt
	mkdir -p `dirname $@`
	-rm $@
	myhome=`pwd` && cd `dirname $@` && RepeatMasker $${myhome}/$< -lib lib/consensi.fa.classified -gff -pa 32
	touch $@

#run repeatmasker on the unscaffolded final canu v2 contigs:
hic_scaf_repmask: temp/repeatmasker/hic_scaf/hic_scaf_repeatmasker_done.txt
temp/repeatmasker/hic_scaf/hic_scaf_repmask_database_done.txt: /data1/jbrown/louse_project/test_cout/pigeon_lice_ctgs_breaks_final.review.fasta
	mkdir -p `dirname $@`
	-rm $@
	rsync -avP $< `dirname $@`
	cd `dirname $@` && BuildDatabase -name louse_hic_scaf `basename $<`
	touch $@
temp/repeatmasker/hic_scaf/hic_scaf_repmodeler_done.txt: temp/repeatmasker/hic_scaf/hic_scaf_repmask_database_done.txt
	mkdir -p `dirname $@`
	mkdir -p `dirname $@`/lib
	-rm $@
	cd `dirname $@` && RepeatModeler -pa 32 -database louse_hic_scaf >& repeatmodeler_out.txt
	mv `dirname $@`/RM_*/consensi* `dirname $@`/lib
	rm -r `dirname $@`/RM_*
	touch $@
temp/repeatmasker/hic_scaf/hic_scaf_repeatmasker_done.txt: /data1/jbrown/louse_project/test_cout/pigeon_lice_ctgs_breaks_final.review.fasta temp/repeatmasker/hic_scaf/hic_scaf_repmodeler_done.txt
	mkdir -p `dirname $@`
	-rm $@
	myhome=`pwd` && cd `dirname $@` && RepeatMasker $${myhome}/$< -lib lib/consensi.fa.classified -gff -pa 32
	touch $@

################################################################################
################################################################################

#do censoring based on coverage for the portion of the CLC (anna's) assembly that blasts to pediculus, inbred reads:
clc_inbred_covcens: temp/covcens/clc_inbred/clc_inbred_covcens_done.txt
temp/covcens/clc_inbred/clc_inbred_covcens_gotgoods.txt: scripts/util/make_cens_list.R temp/bwa_gatk/anna_assembly_inbred_pedcons2/data/snp_tables/only-PASS-Q30-SNPs.txt
	mkdir -p `dirname $@`
	-rm $@
	Rscript $^ 10 300 2 `dirname $@`/clc_inbred_covcens_goods.txt 1
	touch $@
#infile <- as.character(args[1])
#mincov <- as.numeric(args[2])
#maxcov <- as.numeric(args[3])
#covsdthresh <- as.numeric(args[4])
#outpath <- as.character(args[5])
#numpops <- as.numeric(args[6])
temp/covcens/clc_inbred/clc_inbred_covcens_done.txt: scripts/util/censor_master.py temp/bwa_gatk/anna_assembly_inbred_pedcons2/data/snp_tables/only-PASS-Q30-SNPs.txt temp/covcens/clc_inbred/clc_inbred_covcens_gotgoods.txt
	mkdir -p `dirname $@`
	-rm $@
	python $< temp/bwa_gatk/anna_assembly_inbred_pedcons2/data/snp_tables/only-PASS-Q30-SNPs.txt temp/covcens/clc_inbred/clc_inbred_covcens_goods.txt --header -z > `dirname $@`/clc_inbred_covcens.txt
	touch $@
#parser=argparse.ArgumentParser(description = "censor SNP table based on a table of known good SNPs")
#parser.add_argument("snptable",help="the SNP table to be censored")
#parser.add_argument("good_snps", help="list of known good SNPs (each line should contain the SNP number and a value of 'Good' or 'Bad'")
#parser.add_argument("--header", help="boolean value indicating if the snptable has a header line",action="store_true")
#parser.add_argument("-c","--column", help="column containing SNP number (by default, SNP order in file is used)")
#parser.add_argument("-g","--goodval", help="value from 'good_snps' to indicate good SNPs. By default, either 'Good', 'good', 'GOOD', 'True', 'true', or 'TRUE'.")
#parser.add_argument("-z","--notzero", help="boolean value indicating that good snp indices start at '1' instead of '0', while the snptable starts at 0",action="store_true")

#do censoring based on coverage for the portion of the CLC (anna's) assembly that blasts to pediculus, outbred reads:
clc_outbred_covcens: temp/covcens/clc_outbred/clc_outbred_covcens_done.txt
temp/covcens/clc_outbred/clc_outbred_covcens_gotgoods.txt: scripts/util/make_cens_list.R temp/bwa_gatk/anna_assembly_outbred_pedcons2/data/snp_tables/only-PASS-Q30-SNPs.txt
	mkdir -p `dirname $@`
	-rm $@
	Rscript $^ 10 300 2 `dirname $@`/clc_outbred_covcens_goods.txt 1
	touch $@
temp/covcens/clc_outbred/clc_outbred_covcens_done.txt: scripts/util/censor_master.py temp/bwa_gatk/anna_assembly_outbred_pedcons2/data/snp_tables/only-PASS-Q30-SNPs.txt temp/covcens/clc_outbred/clc_outbred_covcens_gotgoods.txt
	mkdir -p `dirname $@`
	-rm $@
	python $< temp/bwa_gatk/anna_assembly_outbred_pedcons2/data/snp_tables/only-PASS-Q30-SNPs.txt temp/covcens/clc_outbred/clc_outbred_covcens_goods.txt --header -z > `dirname $@`/clc_outbred_covcens.txt
	touch $@
#do censoring based on coverage for the portion of the CLC (anna's) assembly that blasts to pediculus, inbred reads, extra severe::
clc_inbred_covcens_strict: temp/covcens/clc_inbred/clc_inbred_covcens_done_strict.txt temp/covcens/clc_inbred/clc_inbred_covcens_done_strict_bed.txt
temp/covcens/clc_inbred/clc_inbred_covcens_gotgoods_strict.txt: scripts/util/make_cens_list.R temp/bwa_gatk/anna_assembly_inbred_pedcons2/data/snp_tables/only-PASS-Q30-SNPs.txt
	mkdir -p `dirname $@`
	-rm $@
	Rscript $^ 10 300 1 `dirname $@`/clc_inbred_covcens_goods_strict.txt 1
	touch $@
temp/covcens/clc_inbred/clc_inbred_covcens_done_strict.txt: scripts/util/censor_master.py temp/bwa_gatk/anna_assembly_inbred_pedcons2/data/snp_tables/only-PASS-Q30-SNPs.txt temp/covcens/clc_inbred/clc_inbred_covcens_gotgoods_strict.txt
	mkdir -p `dirname $@`
	-rm $@
	python $< temp/bwa_gatk/anna_assembly_inbred_pedcons2/data/snp_tables/only-PASS-Q30-SNPs.txt temp/covcens/clc_inbred/clc_inbred_covcens_goods_strict.txt --header -z > `dirname $@`/clc_inbred_covcens_strict.txt
	touch $@
temp/covcens/clc_inbred/clc_inbred_covcens_done_strict_bed.txt: scripts/util/snptable_to_bed.py temp/covcens/clc_inbred/clc_inbred_covcens_done_strict.txt
	mkdir -p `dirname $@`
	-rm $@
	python $< temp/covcens/clc_inbred/clc_inbred_covcens_strict.txt > `dirname $@`/clc_inbred_covcens_strict.bed
	touch $@
temp/covcens/intersect/strict_inbredintersect_done.txt: temp/covcens/clc_outbred/clc_outbred_covcens_done_strict_bed.txt temp/covcens/clc_inbred/clc_inbred_covcens_done_strict_bed.txt
	mkdir -p `dirname $@`
	-rm $@
	bedtools intersect -a temp/covcens/clc_inbred/clc_inbred_covcens_strict.bed -b temp/covcens/clc_outbred/clc_outbred_covcens_strict.bed > `dirname $@`/strict_inbredintersect.bed
	touch $@
temp/covcens/intersect/strict_inbred_to_repmask_done.txt: temp/covcens/clc_inbred/clc_inbred_covcens_done_strict_bed.txt temp/repeatmasker/pedcons/pedcons_repeatmasker_done.txt
	mkdir -p `dirname $@`
	-rm $@
	bedtools intersect -a temp/covcens/clc_inbred/clc_inbred_covcens_strict.bed -b temp/repeatmasker/pedcons/anna_assembly_to_nr_R1-ex.fasta.out.gff -v > `dirname $@`/strict_inbred_to_repmask.bed
	touch $@
temp/covcens/intersect/strict_inbredintersect_to_repmask_done.txt: temp/covcens/intersect/strict_inbredintersect_done.txt temp/repeatmasker/pedcons/pedcons_repeatmasker_done.txt
	mkdir -p `dirname $@`
	-rm $@
	bedtools intersect -a temp/covcens/intersect/strict_inbredintersect.bed -b temp/repeatmasker/pedcons/anna_assembly_to_nr_R1-ex.fasta.out.gff -v > `dirname $@`/strict_inbred_to_repmask.bed
	touch $@
#do censoring based on coverage for the portion of the CLC (anna's) assembly that blasts to pediculus, outbred reads, extra severe:
clc_outbred_covcens_strict: temp/covcens/clc_outbred/clc_outbred_covcens_done_strict.txt temp/covcens/clc_outbred/clc_outbred_covcens_done_strict_bed.txt
temp/covcens/clc_outbred/clc_outbred_covcens_gotgoods_strict.txt: scripts/util/make_cens_list.R temp/bwa_gatk/anna_assembly_outbred_pedcons2/data/snp_tables/only-PASS-Q30-SNPs.txt
	mkdir -p `dirname $@`
	-rm $@
	Rscript $^ 10 300 1 `dirname $@`/clc_outbred_covcens_goods_strict.txt 1
	touch $@
temp/covcens/clc_outbred/clc_outbred_covcens_done_strict.txt: scripts/util/censor_master.py temp/bwa_gatk/anna_assembly_outbred_pedcons2/data/snp_tables/only-PASS-Q30-SNPs.txt temp/covcens/clc_outbred/clc_outbred_covcens_gotgoods_strict.txt
	mkdir -p `dirname $@`
	-rm $@
	python $< temp/bwa_gatk/anna_assembly_outbred_pedcons2/data/snp_tables/only-PASS-Q30-SNPs.txt temp/covcens/clc_outbred/clc_outbred_covcens_goods_strict.txt --header -z > `dirname $@`/clc_outbred_covcens_strict.txt
	touch $@
temp/covcens/clc_outbred/clc_outbred_covcens_done_strict_bed.txt: scripts/util/snptable_to_bed.py temp/covcens/clc_outbred/clc_outbred_covcens_done_strict.txt
	mkdir -p `dirname $@`
	-rm $@
	python $< temp/covcens/clc_outbred/clc_outbred_covcens_strict.txt > `dirname $@`/clc_outbred_covcens_strict.bed
	touch $@
temp/covcens/intersect/strict_outbredintersect_done.txt: temp/covcens/clc_outbred/clc_outbred_covcens_done_strict_bed.txt temp/covcens/clc_inbred/clc_inbred_covcens_done_strict_bed.txt
	mkdir -p `dirname $@`
	-rm $@
	bedtools intersect -a temp/covcens/clc_outbred/clc_outbred_covcens_strict.bed -b temp/covcens/clc_inbred/clc_inbred_covcens_strict.bed > `dirname $@`/strict_outbredintersect.bed
	touch $@
temp/covcens/intersect/strict_outbred_to_repmask_done.txt: temp/covcens/clc_outbred/clc_outbred_covcens_done_strict_bed.txt temp/repeatmasker/pedcons/pedcons_repeatmasker_done.txt
	mkdir -p `dirname $@`
	-rm $@
	bedtools intersect -a temp/covcens/clc_outbred/clc_outbred_covcens_strict.bed -b temp/repeatmasker/pedcons/anna_assembly_to_nr_R1-ex.fasta.out.gff -v > `dirname $@`/strict_outbred_to_repmask.bed
	touch $@
temp/covcens/intersect/strict_outbredintersect_to_repmask_done.txt: temp/covcens/intersect/strict_outbredintersect_done.txt temp/repeatmasker/pedcons/pedcons_repeatmasker_done.txt
	mkdir -p `dirname $@`
	-rm $@
	bedtools intersect -a temp/covcens/intersect/strict_outbredintersect.bed -b temp/repeatmasker/pedcons/anna_assembly_to_nr_R1-ex.fasta.out.gff -v > `dirname $@`/strict_outbred_to_repmask.bed
	touch $@

covcens_intersect: temp/covcens/intersect/strict_inbredintersect_done.txt temp/covcens/intersect/strict_outbredintersect_done.txt temp/covcens/intersect/strict_outbred_to_repmask_done.txt temp/covcens/intersect/strict_inbred_to_repmask_done.txt temp/covcens/intersect/strict_outbredintersect_to_repmask_done.txt temp/covcens/intersect/strict_inbredintersect_to_repmask_done.txt

################################################################################
################################################################################

#do censoring based on whole genome coverage, not just snp coverage:
covcens2: temp/covcens2/pedcons_outbred/pedcons_outbred_bamcov.txt temp/covcens2/pedcons_inbred/pedcons_inbred_bamcov.txt temp/covcens2/pedcons_inbred/pedcons_inbred_bamcov_goods_done.txt temp/covcens2/pedcons_outbred/pedcons_outbred_bamcov_goods_done.txt temp/covcens2/intersect/merge_goods_done temp/covcens2/intersect/inbred_goods_norepeats_done.txt temp/covcens2/intersect/outbred_goods_norepeats_done.txt
temp/covcens2/pedcons_outbred/pedcons_outbred_bamcov.txt: temp/bwa_gatk/anna_assembly_outbred_pedcons2/data/gatk/merged-realigned.bam
	mkdir -p `dirname $@`
	-rm $@
	bedtools genomecov -ibam $< -bg > $@
temp/covcens2/pedcons_outbred/pedcons_outbred_bamcov_goods_done.txt: scripts/util/make_cens_list_col.R temp/covcens2/pedcons_outbred/pedcons_outbred_bamcov.txt
	mkdir -p `dirname $@`
	-rm $@
	Rscript $^ 10 300 1 `dirname $@`/pedcons_outbred_bamcov_goods.txt 4
	touch $@
temp/covcens2/pedcons_outbred/pedcons_outbred_bamcov_cens_done.txt: scripts/util/censor_master.py temp/covcens2/pedcons_outbred/pedcons_outbred_bamcov_goods_done.txt
	mkdir -p `dirname $@`
	-rm $@
	python $< temp/covcens2/pedcons_outbred/pedcons_outbred_bamcov.txt `dirname $@`/pedcons_outbred_bamcov_goods.txt --header -z > `dirname $@`/pedcons_outbred_bamcov_cens.txt
	touch $@
temp/covcens2/pedcons_outbred/unmodified_outbred_snp_table.bed: scripts/util/snptable_to_bed.py temp/bwa_gatk/anna_assembly_outbred_pedcons2/data/snp_tables/only-PASS-Q30-SNPs.txt
	mkdir -p `dirname $@`
	-rm $@
	python $^ > $@
	touch $@
#inbred:
temp/covcens2/pedcons_inbred/pedcons_inbred_bamcov.txt: temp/bwa_gatk/anna_assembly_inbred_pedcons2/data/gatk/merged-realigned.bam
	mkdir -p `dirname $@`
	-rm $@
	bedtools genomecov -ibam $< -bg > $@
temp/covcens2/pedcons_inbred/pedcons_inbred_bamcov_goods_done.txt: scripts/util/make_cens_list_col.R temp/covcens2/pedcons_inbred/pedcons_inbred_bamcov.txt
	mkdir -p `dirname $@`
	-rm $@
	Rscript $^ 10 300 1 `dirname $@`/pedcons_inbred_bamcov_goods.txt 4
	touch $@
temp/covcens2/pedcons_inbred/pedcons_inbred_bamcov_cens_done.txt: scripts/util/censor_master.py temp/covcens2/pedcons_inbred/pedcons_inbred_bamcov_goods_done.txt
	mkdir -p `dirname $@`
	-rm $@
	python $< temp/covcens2/pedcons_inbred/pedcons_inbred_bamcov.txt `dirname $@`/pedcons_inbred_bamcov_goods.txt --header -z > `dirname $@`/pedcons_inbred_bamcov_cens.txt
	touch $@
temp/covcens2/pedcons_inbred/unmodified_inbred_snp_table.bed: scripts/util/snptable_to_bed.py temp/bwa_gatk/anna_assembly_inbred_pedcons2/data/snp_tables/only-PASS-Q30-SNPs.txt
	mkdir -p `dirname $@`
	-rm $@
	python $^ > $@
	touch $@

temp/covcens2/intersect/merge_goods_done: temp/covcens2/pedcons_inbred/pedcons_inbred_bamcov_cens_done.txt temp/covcens2/pedcons_outbred/pedcons_outbred_bamcov_cens_done.txt
	mkdir -p `dirname $@`
	-rm $@
	bedtools merge -i <(cat temp/covcens2/pedcons_inbred/pedcons_inbred_bamcov_cens.txt temp/covcens2/pedcons_outbred/pedcons_outbred_bamcov_cens.txt | sort -k 1,1 -k 2,2n -k 3,3n) > `dirname $@`/merged_goods.bed
	touch $@
temp/covcens2/intersect/goods_norepeats_done.txt: temp/covcens2/intersect/merge_goods_done temp/repeatmasker/pedcons/pedcons_repeatmasker_done.txt
	mkdir -p `dirname $@`
	-rm $@
	bedtools intersect -a temp/covcens2/intersect/merged_goods.bed -b temp/repeatmasker/pedcons/anna_assembly_to_nr_R1-ex.fasta.out.gff -v > `dirname $@`/goods_norepeats.bed
	touch $@
temp/covcens2/intersect/inbred_goods_norepeats_done.txt: temp/covcens2/pedcons_inbred/unmodified_inbred_snp_table.bed temp/covcens2/intersect/goods_norepeats_done.txt
	mkdir -p `dirname $@`
	-rm $@
	bedtools intersect -a temp/covcens2/pedcons_inbred/unmodified_inbred_snp_table.bed -b temp/covcens2/intersect/goods_norepeats.bed > `dirname $@`/inbred_goods_norepeats.bed
	touch $@
temp/covcens2/intersect/outbred_goods_norepeats_done.txt: temp/covcens2/pedcons_outbred/unmodified_outbred_snp_table.bed temp/covcens2/intersect/goods_norepeats_done.txt
	mkdir -p `dirname $@`
	-rm $@
	bedtools intersect -a temp/covcens2/pedcons_outbred/unmodified_outbred_snp_table.bed -b temp/covcens2/intersect/goods_norepeats.bed > `dirname $@`/outbred_goods_norepeats.bed
	touch $@

#inbred and outbred snp allele freq histo, post censoring:
plot_af_io_covcens2: plots/covcens2/intersect/covcens2_snp_full_cens_poly_plotted_inbredoutbred.pdf
temp/covcens2/intersect/covcens2_full_cens_poly_plotted_inbredoutbred.pdf: scripts/allele_freq/plot_af_inbredoutbred_bed.R temp/covcens2/intersect/inbred_goods_norepeats_done.txt temp/covcens2/intersect/outbred_goods_norepeats_done.txt
	-rm $@
	Rscript $< temp/covcens2/intersect/inbred_goods_norepeats.bed temp/covcens2/intersect/outbred_goods_norepeats.bed $@
plots/covcens2/intersect/covcens2_snp_full_cens_poly_plotted_inbredoutbred.pdf: temp/covcens2/intersect/covcens2_full_cens_poly_plotted_inbredoutbred.pdf
	mkdir -p `dirname $@`
	-rm $@
	rsync -avP $< $@

#indels:

plot_af_io_covcens2_indel: plots/covcens2/intersect/covcens2_indel_full_cens_poly_plotted_inbredoutbred.pdf
temp/covcens2/pedcons_outbred/unmodified_outbred_indel_table.bed: scripts/util/snptable_to_bed.py temp/bwa_gatk/anna_assembly_outbred_pedcons2/data/snp_tables/only-PASS-Q30-INDEL.txt
	mkdir -p `dirname $@`
	-rm $@
	python $^ > $@
	touch $@
temp/covcens2/pedcons_inbred/unmodified_inbred_indel_table.bed: scripts/util/snptable_to_bed.py temp/bwa_gatk/anna_assembly_inbred_pedcons2/data/snp_tables/only-PASS-Q30-INDEL.txt
	mkdir -p `dirname $@`
	-rm $@
	python $^ > $@
	touch $@
temp/covcens2/intersect/inbred_indel_goods_norepeats_done.txt: temp/covcens2/pedcons_inbred/unmodified_inbred_indel_table.bed temp/covcens2/intersect/goods_norepeats_done.txt
	mkdir -p `dirname $@`
	-rm $@
	bedtools intersect -a temp/covcens2/pedcons_inbred/unmodified_inbred_indel_table.bed -b temp/covcens2/intersect/goods_norepeats.bed > `dirname $@`/inbred_indel_goods_norepeats.bed
	touch $@
temp/covcens2/intersect/outbred_indel_goods_norepeats_done.txt: temp/covcens2/pedcons_outbred/unmodified_outbred_indel_table.bed temp/covcens2/intersect/goods_norepeats_done.txt
	mkdir -p `dirname $@`
	-rm $@
	bedtools intersect -a temp/covcens2/pedcons_outbred/unmodified_outbred_indel_table.bed -b temp/covcens2/intersect/goods_norepeats.bed > `dirname $@`/outbred_indel_goods_norepeats.bed
	touch $@
temp/covcens2/intersect/covcens2_indel_full_cens_poly_plotted_inbredoutbred.pdf: scripts/allele_freq/plot_af_inbredoutbred_bed.R temp/covcens2/intersect/inbred_indel_goods_norepeats_done.txt temp/covcens2/intersect/outbred_indel_goods_norepeats_done.txt
	-rm $@
	Rscript $< temp/covcens2/intersect/inbred_indel_goods_norepeats.bed temp/covcens2/intersect/outbred_indel_goods_norepeats.bed $@
plots/covcens2/intersect/covcens2_indel_full_cens_poly_plotted_inbredoutbred.pdf: temp/covcens2/intersect/covcens2_indel_full_cens_poly_plotted_inbredoutbred.pdf
	mkdir -p `dirname $@`
	-rm $@
	rsync -avP $< $@

#heterozygosities:
covcens_hets: temp/covcens2/intersect/covcens2_inbred_indel_full_cens_avg_het.txt temp/covcens2/intersect/covcens2_outbred_indel_full_cens_avg_het.txt temp/covcens2/intersect/covcens2_inbred_snp_full_cens_avg_het.txt temp/covcens2/intersect/covcens2_outbred_snp_full_cens_avg_het.txt
temp/covcens2/intersect/covcens2_inbred_indel_full_cens_avg_het.txt: scripts/allele_freq/calc_het_column.py temp/bwa_gatk/anna_assembly_outbred_pedcons2/data/snp_tables/only-PASS-Q30-SNPs_split_poly.txt temp/covcens2/intersect/inbred_indel_goods_norepeats_done.txt
	-rm $@
	python $< temp/covcens2/intersect/inbred_indel_goods_norepeats.bed `dirname $@`/`basename $@ _avg_het.txt` 6 35235095
temp/covcens2/intersect/covcens2_outbred_indel_full_cens_avg_het.txt: scripts/allele_freq/calc_het_column.py temp/bwa_gatk/anna_assembly_outbred_pedcons2/data/snp_tables/only-PASS-Q30-SNPs_split_poly.txt temp/covcens2/intersect/outbred_indel_goods_norepeats_done.txt
	-rm $@
	python $< temp/covcens2/intersect/outbred_indel_goods_norepeats.bed `dirname $@`/`basename $@ _avg_het.txt` 6 35235095
temp/covcens2/intersect/covcens2_inbred_snp_full_cens_avg_het.txt: scripts/allele_freq/calc_het_column.py temp/bwa_gatk/anna_assembly_outbred_pedcons2/data/snp_tables/only-PASS-Q30-SNPs_split_poly.txt temp/covcens2/intersect/inbred_goods_norepeats_done.txt
	-rm $@
	python $< temp/covcens2/intersect/inbred_goods_norepeats.bed `dirname $@`/`basename $@ _avg_het.txt` 6 35235095
temp/covcens2/intersect/covcens2_outbred_snp_full_cens_avg_het.txt: scripts/allele_freq/calc_het_column.py temp/bwa_gatk/anna_assembly_outbred_pedcons2/data/snp_tables/only-PASS-Q30-SNPs_split_poly.txt temp/covcens2/intersect/outbred_goods_norepeats_done.txt
	-rm $@
	python $< temp/covcens2/intersect/outbred_goods_norepeats.bed `dirname $@`/`basename $@ _avg_het.txt` 6 35235095

################################################################################
################################################################################

#MinION basecalling:
basecall_minion: temp/minion_basecalling/1/basecalling_1_done.txt temp/minion_basecalling/2/basecalling_2_done.txt temp/minion_basecalling/3/basecalling_3_done.txt temp/minion_basecalling/4/basecalling_4_done.txt temp/minion_basecalling/5/basecalling_5_done.txt

temp/minion_basecalling/1/basecalling_1_done.txt: scripts/minion/run_albacore_minion_v1.sh
	mkdir -p `dirname $@`
	-rm $@
	bash $<
	touch $@

temp/minion_basecalling/2/basecalling_2_done.txt: scripts/minion/run_albacore_minion_v2.sh
	mkdir -p `dirname $@`
	-rm $@
	bash $<
	touch $@

temp/minion_basecalling/3/basecalling_3_done.txt: scripts/minion/run_albacore_minion_v3.sh
	mkdir -p `dirname $@`
	-rm $@
	bash $<
	touch $@

temp/minion_basecalling/4/basecalling_4_done.txt: scripts/minion/run_albacore_minion_v4.sh
	mkdir -p `dirname $@`
	-rm $@
	bash $<
	touch $@

temp/minion_basecalling/5/basecalling_5_done.txt: scripts/minion/run_albacore_minion_v5.sh
	mkdir -p `dirname $@`
	-rm $@
	bash $<
	touch $@

#MinION quality and length distribs (unfinished):
minion_tempdist: temp/minion_basecalling/1/tempdist/temp1_1d_quals_mean.txt temp/minion_basecalling/1/tempdist/temp1_1d_quals_hist.pdf temp/minion_basecalling/1/tempdist/temp1_1d_lens_hist.pdf temp/minion_basecalling/1/tempdist/temp1_1d_lens_hist2.pdf temp/minion_basecalling/1/tempdist/temp1_1dsq_quals_mean.txt temp/minion_basecalling/1/tempdist/temp1_1dsq_quals_hist.pdf temp/minion_basecalling/1/tempdist/temp1_1dsq_lens_hist.pdf temp/minion_basecalling/1/tempdist/temp1_1dsq_lens_hist2.pdf temp/minion_basecalling/1/tempdist/temp1_1dsq_lens_hist3.pdf temp/minion_basecalling/1/tempdist/temp1_1d_lens_hist3.pdf
temp/minion_basecalling/1/tempdist/temp1_1d_quals.txt: scripts/util/calculate_average_read_quality.py temp/minion_basecalling/1/temp_1d.fastq
	mkdir -p `dirname $@`
	-rm $@
	python $^ > $@
	touch $@
temp/minion_basecalling/1/tempdist/temp1_1d_quals_mean.txt: scripts/util/mean temp/minion_basecalling/1/tempdist/temp1_1d_quals.txt
	mkdir -p `dirname $@`
	-rm $@
	python $^ > $@
	touch $@
temp/minion_basecalling/1/tempdist/temp1_1d_quals_hist.pdf: scripts/util/hist temp/minion_basecalling/1/tempdist/temp1_1d_quals.txt
	mkdir -p `dirname $@`
	-rm $@
	Rscript $^ $@
	touch $@
temp/minion_basecalling/1/tempdist/temp1_1d_lens.txt: scripts/util/read_lengths.py temp/minion_basecalling/1/temp_1d.fastq
	mkdir -p `dirname $@`
	-rm $@
	python $^ > $@
	touch $@
temp/minion_basecalling/1/tempdist/temp1_1d_lens_hist.pdf: scripts/util/hist temp/minion_basecalling/1/tempdist/temp1_1d_lens.txt
	mkdir -p `dirname $@`
	-rm $@
	Rscript $^ $@
	touch $@
temp/minion_basecalling/1/tempdist/temp1_1d_stats.txt: scripts/util/fqstatsqual.py temp/minion_basecalling/1/temp_1d.fastq
	mkdir -p `dirname $@`
	-rm $@
	python $^ > $@
temp/minion_basecalling/1/tempdist/temp1_1d_lens_hist2.pdf: scripts/util/fq_read_hist temp/minion_basecalling/1/tempdist/temp1_1d_lens.txt
	mkdir -p `dirname $@`
	-rm $@
	Rscript $^ $@
	touch $@
temp/minion_basecalling/1/tempdist/temp1_1d_lens_hist3.pdf: scripts/util/fq_qual_hist_flex_top temp/minion_basecalling/1/tempdist/temp1_1d_lens.txt
	mkdir -p `dirname $@`
	-rm $@
	Rscript $^ $@
	touch $@

temp/minion_basecalling/1/tempdist/temp1_1dsq_quals.txt: scripts/util/calculate_average_read_quality.py temp/minion_basecalling/1/temp_1dsq.fastq
	mkdir -p `dirname $@`
	-rm $@
	python $^ > $@
	touch $@
temp/minion_basecalling/1/tempdist/temp1_1dsq_quals_mean.txt: scripts/util/mean temp/minion_basecalling/1/tempdist/temp1_1dsq_quals.txt
	mkdir -p `dirname $@`
	-rm $@
	python $^ > $@
	touch $@
temp/minion_basecalling/1/tempdist/temp1_1dsq_quals_hist.pdf: scripts/util/hist temp/minion_basecalling/1/tempdist/temp1_1dsq_quals.txt
	mkdir -p `dirname $@`
	-rm $@
	Rscript $^ $@
	touch $@
temp/minion_basecalling/1/tempdist/temp1_1dsq_lens.txt: scripts/util/read_lengths.py temp/minion_basecalling/1/temp_1dsq.fastq
	mkdir -p `dirname $@`
	-rm $@
	python $^ > $@
	touch $@
temp/minion_basecalling/1/tempdist/temp1_1dsq_lens_hist.pdf: scripts/util/hist temp/minion_basecalling/1/tempdist/temp1_1dsq_lens.txt
	mkdir -p `dirname $@`
	-rm $@
	Rscript $^ $@
	touch $@
temp/minion_basecalling/1/tempdist/temp1_1dsq_stats.txt: scripts/util/fqstatsqual.py temp/minion_basecalling/1/temp_1dsq.fastq
	mkdir -p `dirname $@`
	-rm $@
	python $^ > $@
temp/minion_basecalling/1/tempdist/temp1_1dsq_lens_hist2.pdf: scripts/util/fq_read_hist temp/minion_basecalling/1/tempdist/temp1_1dsq_lens.txt
	mkdir -p `dirname $@`
	-rm $@
	Rscript $^ $@
	touch $@
temp/minion_basecalling/1/tempdist/temp1_1dsq_lens_hist3.pdf: scripts/util/fq_qual_hist_flex_top temp/minion_basecalling/1/tempdist/temp1_1dsq_lens.txt
	mkdir -p `dirname $@`
	-rm $@
	Rscript $^ $@
	touch $@

#minion quality and length distribs (run 2):
minion2_dist: temp/minion_basecalling/2/dist/minion2_1d_quals_mean.txt temp/minion_basecalling/2/dist/minion2_1d_quals_hist.pdf temp/minion_basecalling/2/dist/minion2_1d_lens_hist.pdf temp/minion_basecalling/2/dist/minion2_1d_lens_hist2.pdf temp/minion_basecalling/2/dist/minion2_1dsq_quals_mean.txt temp/minion_basecalling/2/dist/minion2_1dsq_quals_hist.pdf temp/minion_basecalling/2/dist/minion2_1dsq_lens_hist.pdf temp/minion_basecalling/2/dist/minion2_1dsq_lens_hist2.pdf temp/minion_basecalling/2/dist/minion2_1dsq_lens_hist3.pdf temp/minion_basecalling/2/dist/minion2_1d_lens_hist3.pdf

temp/minion_basecalling/2/dist/minion2_1d_quals.txt: scripts/util/calculate_average_read_quality.py temp/minion_basecalling/2/minion2_1d_combo.fq
	mkdir -p `dirname $@`
	-rm $@
	python $^ > $@
	touch $@
temp/minion_basecalling/2/dist/minion2_1d_quals_mean.txt: scripts/util/mean temp/minion_basecalling/2/dist/minion2_1d_quals.txt
	mkdir -p `dirname $@`
	-rm $@
	python $^ > $@
	touch $@
temp/minion_basecalling/2/dist/minion2_1d_quals_hist.pdf: scripts/util/hist temp/minion_basecalling/2/dist/minion2_1d_quals.txt
	mkdir -p `dirname $@`
	-rm $@
	Rscript $^ $@
	touch $@
temp/minion_basecalling/2/dist/minion2_1d_lens.txt: scripts/util/read_lengths.py temp/minion_basecalling/2/minion2_1d_combo.fq
	mkdir -p `dirname $@`
	-rm $@
	python $^ > $@
	touch $@
temp/minion_basecalling/2/dist/minion2_1d_lens_hist.pdf: scripts/util/hist temp/minion_basecalling/2/dist/minion2_1d_lens.txt
	mkdir -p `dirname $@`
	-rm $@
	Rscript $^ $@
	touch $@
temp/minion_basecalling/2/dist/minion2_1d_stats.txt: scripts/util/fqstatsqual.py temp/minion_basecalling/minion2_1d_combo.fq
	mkdir -p `dirname $@`
	-rm $@
	python $^ > $@
temp/minion_basecalling/2/dist/minion2_1d_lens_hist2.pdf: scripts/util/fq_read_hist temp/minion_basecalling/2/dist/minion2_1d_lens.txt
	mkdir -p `dirname $@`
	-rm $@
	Rscript $^ $@
	touch $@
temp/minion_basecalling/2/dist/minion2_1d_lens_hist3.pdf: scripts/util/fq_qual_hist_flex_top temp/minion_basecalling/2/dist/minion2_1d_lens.txt
	mkdir -p `dirname $@`
	-rm $@
	Rscript $^ $@
	touch $@

temp/minion_basecalling/2/dist/minion2_1dsq_quals.txt: scripts/util/calculate_average_read_quality.py temp/minion_basecalling/2/minion2_1dsq_combo.fq
	mkdir -p `dirname $@`
	-rm $@
	python $^ > $@
	touch $@
temp/minion_basecalling/2/dist/minion2_1dsq_quals_mean.txt: scripts/util/mean temp/minion_basecalling/2/dist/minion2_1dsq_quals.txt
	mkdir -p `dirname $@`
	-rm $@
	python $^ > $@
	touch $@
temp/minion_basecalling/2/dist/minion2_1dsq_quals_hist.pdf: scripts/util/hist temp/minion_basecalling/2/dist/minion2_1dsq_quals.txt
	mkdir -p `dirname $@`
	-rm $@
	Rscript $^ $@
	touch $@
temp/minion_basecalling/2/dist/minion2_1dsq_lens.txt: scripts/util/read_lengths.py temp/minion_basecalling/2/minion2_1dsq_combo.fq
	mkdir -p `dirname $@`
	-rm $@
	python $^ > $@
	touch $@
temp/minion_basecalling/2/dist/minion2_1dsq_lens_hist.pdf: scripts/util/hist temp/minion_basecalling/2/dist/minion2_1dsq_lens.txt
	mkdir -p `dirname $@`
	-rm $@
	Rscript $^ $@
	touch $@
temp/minion_basecalling/2/dist/minion2_1dsq_stats.txt: scripts/util/fqstatsqual.py temp/minion_basecalling/2/minion2_1dsq_combo.fq
	mkdir -p `dirname $@`
	-rm $@
	python $^ > $@
temp/minion_basecalling/2/dist/minion2_1dsq_lens_hist2.pdf: scripts/util/fq_read_hist temp/minion_basecalling/2/dist/minion2_1dsq_lens.txt
	mkdir -p `dirname $@`
	-rm $@
	Rscript $^ $@
	touch $@
temp/minion_basecalling/2/dist/minion2_1dsq_lens_hist3.pdf: scripts/util/fq_qual_hist_flex_top temp/minion_basecalling/2/dist/minion2_1dsq_lens.txt
	mkdir -p `dirname $@`
	-rm $@
	Rscript $^ $@
	touch $@

#minion quality and length distribs (run 3):
minion3_dist: temp/minion_basecalling/3/dist/minion3_1d_quals_mean.txt temp/minion_basecalling/3/dist/minion3_1d_quals_hist.pdf temp/minion_basecalling/3/dist/minion3_1d_lens_hist.pdf temp/minion_basecalling/3/dist/minion3_1d_lens_hist2.pdf temp/minion_basecalling/3/dist/minion3_1dsq_quals_mean.txt temp/minion_basecalling/3/dist/minion3_1dsq_quals_hist.pdf temp/minion_basecalling/3/dist/minion3_1dsq_lens_hist.pdf temp/minion_basecalling/3/dist/minion3_1dsq_lens_hist2.pdf temp/minion_basecalling/3/dist/minion3_1dsq_lens_hist3.pdf temp/minion_basecalling/3/dist/minion3_1d_lens_hist3.pdf

temp/minion_basecalling/3/dist/minion3_1d_quals.txt: scripts/util/calculate_average_read_quality.py temp/minion_basecalling/3/minion3_1d_combo.fq
	mkdir -p `dirname $@`
	-rm $@
	python $^ > $@
	touch $@
temp/minion_basecalling/3/dist/minion3_1d_quals_mean.txt: scripts/util/mean temp/minion_basecalling/3/dist/minion3_1d_quals.txt
	mkdir -p `dirname $@`
	-rm $@
	python $^ > $@
	touch $@
temp/minion_basecalling/3/dist/minion3_1d_quals_hist.pdf: scripts/util/hist temp/minion_basecalling/3/dist/minion3_1d_quals.txt
	mkdir -p `dirname $@`
	-rm $@
	Rscript $^ $@
	touch $@
temp/minion_basecalling/3/dist/minion3_1d_lens.txt: scripts/util/read_lengths.py temp/minion_basecalling/3/minion3_1d_combo.fq
	mkdir -p `dirname $@`
	-rm $@
	python $^ > $@
	touch $@
temp/minion_basecalling/3/dist/minion3_1d_lens_hist.pdf: scripts/util/hist temp/minion_basecalling/3/dist/minion3_1d_lens.txt
	mkdir -p `dirname $@`
	-rm $@
	Rscript $^ $@
	touch $@
temp/minion_basecalling/3/dist/minion3_1d_stats.txt: scripts/util/fqstatsqual.py temp/minion_basecalling/minion3_1d_combo.fq
	mkdir -p `dirname $@`
	-rm $@
	python $^ > $@
temp/minion_basecalling/3/dist/minion3_1d_lens_hist2.pdf: scripts/util/fq_read_hist temp/minion_basecalling/3/dist/minion3_1d_lens.txt
	mkdir -p `dirname $@`
	-rm $@
	Rscript $^ $@
	touch $@
temp/minion_basecalling/3/dist/minion3_1d_lens_hist3.pdf: scripts/util/fq_qual_hist_flex_top temp/minion_basecalling/3/dist/minion3_1d_lens.txt
	mkdir -p `dirname $@`
	-rm $@
	Rscript $^ $@
	touch $@

temp/minion_basecalling/3/dist/minion3_1dsq_quals.txt: scripts/util/calculate_average_read_quality.py temp/minion_basecalling/3/minion3_1dsq_combo.fq
	mkdir -p `dirname $@`
	-rm $@
	python $^ > $@
	touch $@
temp/minion_basecalling/3/dist/minion3_1dsq_quals_mean.txt: scripts/util/mean temp/minion_basecalling/3/dist/minion3_1dsq_quals.txt
	mkdir -p `dirname $@`
	-rm $@
	python $^ > $@
	touch $@
temp/minion_basecalling/3/dist/minion3_1dsq_quals_hist.pdf: scripts/util/hist temp/minion_basecalling/3/dist/minion3_1dsq_quals.txt
	mkdir -p `dirname $@`
	-rm $@
	Rscript $^ $@
	touch $@
temp/minion_basecalling/3/dist/minion3_1dsq_lens.txt: scripts/util/read_lengths.py temp/minion_basecalling/3/minion3_1dsq_combo.fq
	mkdir -p `dirname $@`
	-rm $@
	python $^ > $@
	touch $@
temp/minion_basecalling/3/dist/minion3_1dsq_lens_hist.pdf: scripts/util/hist temp/minion_basecalling/3/dist/minion3_1dsq_lens.txt
	mkdir -p `dirname $@`
	-rm $@
	Rscript $^ $@
	touch $@
temp/minion_basecalling/3/dist/minion3_1dsq_stats.txt: scripts/util/fqstatsqual.py temp/minion_basecalling/3/minion3_1dsq_combo.fq
	mkdir -p `dirname $@`
	-rm $@
	python $^ > $@
temp/minion_basecalling/3/dist/minion3_1dsq_lens_hist2.pdf: scripts/util/fq_read_hist temp/minion_basecalling/3/dist/minion3_1dsq_lens.txt
	mkdir -p `dirname $@`
	-rm $@
	Rscript $^ $@
	touch $@
temp/minion_basecalling/3/dist/minion3_1dsq_lens_hist3.pdf: scripts/util/fq_qual_hist_flex_top temp/minion_basecalling/3/dist/minion3_1dsq_lens.txt
	mkdir -p `dirname $@`
	-rm $@
	Rscript $^ $@
	touch $@

#minion quality and length distribs (run 4):
minion4_dist: temp/minion_basecalling/4/dist/minion4_1d_quals_mean.txt temp/minion_basecalling/4/dist/minion4_1d_quals_hist.pdf temp/minion_basecalling/4/dist/minion4_1d_lens_hist.pdf temp/minion_basecalling/4/dist/minion4_1d_lens_hist2.pdf temp/minion_basecalling/4/dist/minion4_1dsq_quals_mean.txt temp/minion_basecalling/4/dist/minion4_1dsq_quals_hist.pdf temp/minion_basecalling/4/dist/minion4_1dsq_lens_hist.pdf temp/minion_basecalling/4/dist/minion4_1dsq_lens_hist2.pdf temp/minion_basecalling/4/dist/minion4_1dsq_lens_hist3.pdf temp/minion_basecalling/4/dist/minion4_1d_lens_hist3.pdf

temp/minion_basecalling/4/dist/minion4_1d_quals.txt: scripts/util/calculate_average_read_quality.py temp/minion_basecalling/4/minion4_1d_combo.fq
	mkdir -p `dirname $@`
	-rm $@
	python $^ > $@
	touch $@
temp/minion_basecalling/4/dist/minion4_1d_quals_mean.txt: scripts/util/mean temp/minion_basecalling/4/dist/minion4_1d_quals.txt
	mkdir -p `dirname $@`
	-rm $@
	python $^ > $@
	touch $@
temp/minion_basecalling/4/dist/minion4_1d_quals_hist.pdf: scripts/util/hist temp/minion_basecalling/4/dist/minion4_1d_quals.txt
	mkdir -p `dirname $@`
	-rm $@
	Rscript $^ $@
	touch $@
temp/minion_basecalling/4/dist/minion4_1d_lens.txt: scripts/util/read_lengths.py temp/minion_basecalling/4/minion4_1d_combo.fq
	mkdir -p `dirname $@`
	-rm $@
	python $^ > $@
	touch $@
temp/minion_basecalling/4/dist/minion4_1d_lens_hist.pdf: scripts/util/hist temp/minion_basecalling/4/dist/minion4_1d_lens.txt
	mkdir -p `dirname $@`
	-rm $@
	Rscript $^ $@
	touch $@
temp/minion_basecalling/4/dist/minion4_1d_stats.txt: scripts/util/fqstatsqual.py temp/minion_basecalling/minion4_1d_combo.fq
	mkdir -p `dirname $@`
	-rm $@
	python $^ > $@
temp/minion_basecalling/4/dist/minion4_1d_lens_hist2.pdf: scripts/util/fq_read_hist temp/minion_basecalling/4/dist/minion4_1d_lens.txt
	mkdir -p `dirname $@`
	-rm $@
	Rscript $^ $@
	touch $@
temp/minion_basecalling/4/dist/minion4_1d_lens_hist3.pdf: scripts/util/fq_qual_hist_flex_top temp/minion_basecalling/4/dist/minion4_1d_lens.txt
	mkdir -p `dirname $@`
	-rm $@
	Rscript $^ $@
	touch $@

temp/minion_basecalling/4/dist/minion4_1dsq_quals.txt: scripts/util/calculate_average_read_quality.py temp/minion_basecalling/4/minion4_1dsq_combo.fq
	mkdir -p `dirname $@`
	-rm $@
	python $^ > $@
	touch $@
temp/minion_basecalling/4/dist/minion4_1dsq_quals_mean.txt: scripts/util/mean temp/minion_basecalling/4/dist/minion4_1dsq_quals.txt
	mkdir -p `dirname $@`
	-rm $@
	python $^ > $@
	touch $@
temp/minion_basecalling/4/dist/minion4_1dsq_quals_hist.pdf: scripts/util/hist temp/minion_basecalling/4/dist/minion4_1dsq_quals.txt
	mkdir -p `dirname $@`
	-rm $@
	Rscript $^ $@
	touch $@
temp/minion_basecalling/4/dist/minion4_1dsq_lens.txt: scripts/util/read_lengths.py temp/minion_basecalling/4/minion4_1dsq_combo.fq
	mkdir -p `dirname $@`
	-rm $@
	python $^ > $@
	touch $@
temp/minion_basecalling/4/dist/minion4_1dsq_lens_hist.pdf: scripts/util/hist temp/minion_basecalling/4/dist/minion4_1dsq_lens.txt
	mkdir -p `dirname $@`
	-rm $@
	Rscript $^ $@
	touch $@
temp/minion_basecalling/4/dist/minion4_1dsq_stats.txt: scripts/util/fqstatsqual.py temp/minion_basecalling/4/minion4_1dsq_combo.fq
	mkdir -p `dirname $@`
	-rm $@
	python $^ > $@
temp/minion_basecalling/4/dist/minion4_1dsq_lens_hist2.pdf: scripts/util/fq_read_hist temp/minion_basecalling/4/dist/minion4_1dsq_lens.txt
	mkdir -p `dirname $@`
	-rm $@
	Rscript $^ $@
	touch $@
temp/minion_basecalling/4/dist/minion4_1dsq_lens_hist3.pdf: scripts/util/fq_qual_hist_flex_top temp/minion_basecalling/4/dist/minion4_1dsq_lens.txt
	mkdir -p `dirname $@`
	-rm $@
	Rscript $^ $@
	touch $@


#minion quality and length distribs (run 5):
minion5_dist: temp/minion_basecalling/5/dist/minion5_1d_quals_mean.txt temp/minion_basecalling/5/dist/minion5_1d_quals_hist.pdf temp/minion_basecalling/5/dist/minion5_1d_lens_hist.pdf temp/minion_basecalling/5/dist/minion5_1d_lens_hist2.pdf temp/minion_basecalling/5/dist/minion5_1dsq_quals_mean.txt temp/minion_basecalling/5/dist/minion5_1dsq_quals_hist.pdf temp/minion_basecalling/5/dist/minion5_1dsq_lens_hist.pdf temp/minion_basecalling/5/dist/minion5_1dsq_lens_hist2.pdf temp/minion_basecalling/5/dist/minion5_1dsq_lens_hist3.pdf temp/minion_basecalling/5/dist/minion5_1d_lens_hist3.pdf

temp/minion_basecalling/5/dist/minion5_1d_quals.txt: scripts/util/calculate_average_read_quality.py temp/minion_basecalling/5/minion5_1d_combo.fq
	mkdir -p `dirname $@`
	-rm $@
	python $^ > $@
	touch $@
temp/minion_basecalling/5/dist/minion5_1d_quals_mean.txt: scripts/util/mean temp/minion_basecalling/5/dist/minion5_1d_quals.txt
	mkdir -p `dirname $@`
	-rm $@
	python $^ > $@
	touch $@
temp/minion_basecalling/5/dist/minion5_1d_quals_hist.pdf: scripts/util/hist temp/minion_basecalling/5/dist/minion5_1d_quals.txt
	mkdir -p `dirname $@`
	-rm $@
	Rscript $^ $@
	touch $@
temp/minion_basecalling/5/dist/minion5_1d_lens.txt: scripts/util/read_lengths.py temp/minion_basecalling/5/minion5_1d_combo.fq
	mkdir -p `dirname $@`
	-rm $@
	python $^ > $@
	touch $@
temp/minion_basecalling/5/dist/minion5_1d_lens_hist.pdf: scripts/util/hist temp/minion_basecalling/5/dist/minion5_1d_lens.txt
	mkdir -p `dirname $@`
	-rm $@
	Rscript $^ $@
	touch $@
temp/minion_basecalling/5/dist/minion5_1d_stats.txt: scripts/util/fqstatsqual.py temp/minion_basecalling/minion5_1d_combo.fq
	mkdir -p `dirname $@`
	-rm $@
	python $^ > $@
temp/minion_basecalling/5/dist/minion5_1d_lens_hist2.pdf: scripts/util/fq_read_hist temp/minion_basecalling/5/dist/minion5_1d_lens.txt
	mkdir -p `dirname $@`
	-rm $@
	Rscript $^ $@
	touch $@
temp/minion_basecalling/5/dist/minion5_1d_lens_hist3.pdf: scripts/util/fq_qual_hist_flex_top temp/minion_basecalling/5/dist/minion5_1d_lens.txt
	mkdir -p `dirname $@`
	-rm $@
	Rscript $^ $@
	touch $@

temp/minion_basecalling/5/dist/minion5_1dsq_quals.txt: scripts/util/calculate_average_read_quality.py temp/minion_basecalling/5/minion5_1dsq_combo.fq
	mkdir -p `dirname $@`
	-rm $@
	python $^ > $@
	touch $@
temp/minion_basecalling/5/dist/minion5_1dsq_quals_mean.txt: scripts/util/mean temp/minion_basecalling/5/dist/minion5_1dsq_quals.txt
	mkdir -p `dirname $@`
	-rm $@
	python $^ > $@
	touch $@
temp/minion_basecalling/5/dist/minion5_1dsq_quals_hist.pdf: scripts/util/hist temp/minion_basecalling/5/dist/minion5_1dsq_quals.txt
	mkdir -p `dirname $@`
	-rm $@
	Rscript $^ $@
	touch $@
temp/minion_basecalling/5/dist/minion5_1dsq_lens.txt: scripts/util/read_lengths.py temp/minion_basecalling/5/minion5_1dsq_combo.fq
	mkdir -p `dirname $@`
	-rm $@
	python $^ > $@
	touch $@
temp/minion_basecalling/5/dist/minion5_1dsq_lens_hist.pdf: scripts/util/hist temp/minion_basecalling/5/dist/minion5_1dsq_lens.txt
	mkdir -p `dirname $@`
	-rm $@
	Rscript $^ $@
	touch $@
temp/minion_basecalling/5/dist/minion5_1dsq_stats.txt: scripts/util/fqstatsqual.py temp/minion_basecalling/5/minion5_1dsq_combo.fq
	mkdir -p `dirname $@`
	-rm $@
	python $^ > $@
temp/minion_basecalling/5/dist/minion5_1dsq_lens_hist2.pdf: scripts/util/fq_read_hist temp/minion_basecalling/5/dist/minion5_1dsq_lens.txt
	mkdir -p `dirname $@`
	-rm $@
	Rscript $^ $@
	touch $@
temp/minion_basecalling/5/dist/minion5_1dsq_lens_hist3.pdf: scripts/util/fq_qual_hist_flex_top temp/minion_basecalling/5/dist/minion5_1dsq_lens.txt
	mkdir -p `dirname $@`
	-rm $@
	Rscript $^ $@
	touch $@

minion12345_dist: temp/minion_basecalling/combo_12345/dist/minion12345_1d_quals_mean.txt temp/minion_basecalling/combo_12345/dist/minion12345_1d_quals_hist.pdf temp/minion_basecalling/combo_12345/dist/minion12345_1d_lens_hist.pdf temp/minion_basecalling/combo_12345/dist/minion12345_1d_lens_hist2.pdf temp/minion_basecalling/combo_12345/dist/minion12345_1dsq_quals_mean.txt temp/minion_basecalling/combo_12345/dist/minion12345_1dsq_quals_hist.pdf temp/minion_basecalling/combo_12345/dist/minion12345_1dsq_lens_hist.pdf temp/minion_basecalling/combo_12345/dist/minion12345_1dsq_lens_hist2.pdf temp/minion_basecalling/combo_12345/dist/minion12345_1dsq_lens_hist3.pdf temp/minion_basecalling/combo_12345/dist/minion12345_1d_lens_hist3.pdf

temp/minion_basecalling/combo_12345/dist/minion12345_1d_quals.txt: scripts/util/calculate_average_read_quality.py temp/minion_basecalling/combo_12345/minion12345_1d_combo.fq
	mkdir -p `dirname $@`
	-rm $@
	python $^ > $@
	touch $@
temp/minion_basecalling/combo_12345/dist/minion12345_1d_quals_mean.txt: scripts/util/mean temp/minion_basecalling/combo_12345/dist/minion12345_1d_quals.txt
	mkdir -p `dirname $@`
	-rm $@
	python $^ > $@
	touch $@
temp/minion_basecalling/combo_12345/dist/minion12345_1d_quals_hist.pdf: scripts/util/hist temp/minion_basecalling/combo_12345/dist/minion12345_1d_quals.txt
	mkdir -p `dirname $@`
	-rm $@
	Rscript $^ $@
	touch $@
temp/minion_basecalling/combo_12345/dist/minion12345_1d_lens.txt: scripts/util/read_lengths.py temp/minion_basecalling/combo_12345/minion12345_1d_combo.fq
	mkdir -p `dirname $@`
	-rm $@
	python $^ > $@
	touch $@
temp/minion_basecalling/combo_12345/dist/minion12345_1d_lens_hist.pdf: scripts/util/hist temp/minion_basecalling/combo_12345/dist/minion12345_1d_lens.txt
	mkdir -p `dirname $@`
	-rm $@
	Rscript $^ $@
	touch $@
temp/minion_basecalling/combo_12345/dist/minion12345_1d_stats.txt: scripts/util/fqstatsqual.py temp/minion_basecalling/minion12345_1d_combo.fq
	mkdir -p `dirname $@`
	-rm $@
	python $^ > $@
temp/minion_basecalling/combo_12345/dist/minion12345_1d_lens_hist2.pdf: scripts/util/fq_read_hist temp/minion_basecalling/combo_12345/dist/minion12345_1d_lens.txt
	mkdir -p `dirname $@`
	-rm $@
	Rscript $^ $@
	touch $@
temp/minion_basecalling/combo_12345/dist/minion12345_1d_lens_hist3.pdf: scripts/util/fq_qual_hist_flex_top temp/minion_basecalling/combo_12345/dist/minion12345_1d_lens.txt
	mkdir -p `dirname $@`
	-rm $@
	Rscript $^ $@
	touch $@

temp/minion_basecalling/combo_12345/dist/minion12345_1dsq_quals.txt: scripts/util/calculate_average_read_quality.py temp/minion_basecalling/combo_12345/minion12345_1dsq_combo.fq
	mkdir -p `dirname $@`
	-rm $@
	python $^ > $@
	touch $@
temp/minion_basecalling/combo_12345/dist/minion12345_1dsq_quals_mean.txt: scripts/util/mean temp/minion_basecalling/combo_12345/dist/minion12345_1dsq_quals.txt
	mkdir -p `dirname $@`
	-rm $@
	python $^ > $@
	touch $@
temp/minion_basecalling/combo_12345/dist/minion12345_1dsq_quals_hist.pdf: scripts/util/hist temp/minion_basecalling/combo_12345/dist/minion12345_1dsq_quals.txt
	mkdir -p `dirname $@`
	-rm $@
	Rscript $^ $@
	touch $@
temp/minion_basecalling/combo_12345/dist/minion12345_1dsq_lens.txt: scripts/util/read_lengths.py temp/minion_basecalling/combo_12345/minion12345_1dsq_combo.fq
	mkdir -p `dirname $@`
	-rm $@
	python $^ > $@
	touch $@
temp/minion_basecalling/combo_12345/dist/minion12345_1dsq_lens_hist.pdf: scripts/util/hist temp/minion_basecalling/combo_12345/dist/minion12345_1dsq_lens.txt
	mkdir -p `dirname $@`
	-rm $@
	Rscript $^ $@
	touch $@
temp/minion_basecalling/combo_12345/dist/minion12345_1dsq_stats.txt: scripts/util/fqstatsqual.py temp/minion_basecalling/combo_12345/minion12345_1dsq_combo.fq
	mkdir -p `dirname $@`
	-rm $@
	python $^ > $@
temp/minion_basecalling/combo_12345/dist/minion12345_1dsq_lens_hist2.pdf: scripts/util/fq_read_hist temp/minion_basecalling/combo_12345/dist/minion12345_1dsq_lens.txt
	mkdir -p `dirname $@`
	-rm $@
	Rscript $^ $@
	touch $@
temp/minion_basecalling/combo_12345/dist/minion12345_1dsq_lens_hist3.pdf: scripts/util/fq_qual_hist_flex_top temp/minion_basecalling/combo_12345/dist/minion12345_1dsq_lens.txt
	mkdir -p `dirname $@`
	-rm $@
	Rscript $^ $@
	touch $@




################################################################################
################################################################################
#concatenate minion data:

minion_concat:

#find . -name '*.fastq' 2>/dev/null | grep -v '1dsq' | grep -v 'combo' | xargs cat > minion1_1d_combo.fq

################################################################################
################################################################################
#basecall minion rna data:
basecall_minion_rna: temp/minion_rna_basecalling/1/basecalling_1_done.txt temp/minion_rna_basecalling/1/minion_rna1_1d_combo.fq temp/minion_rna_basecalling/2/basecalling_2_done.txt temp/minion_rna_basecalling/2/minion_rna2_1d_combo.fq temp/minion_rna_basecalling/3/minion_rna3_1d_combo.fq temp/minion_rna_basecalling/1-3/minion_rna1-3_1d_combo.fq temp/minion_rna_basecalling/4/minion_rna4_1d_combo.fq temp/minion_rna_basecalling/1-4/minion_rna1-4_1d_combo.fq

temp/minion_rna_basecalling/1/basecalling_1_done.txt: scripts/minion_rna/run_albacore_minion_rna_v1.sh
	mkdir -p `dirname $@`
	-rm $@
	bash $<
	touch $@

temp/minion_rna_basecalling/1/minion_rna1_1d_combo.fq: temp/minion_rna_basecalling/1/basecalling_1_done.txt
	find temp/minion_rna_basecalling/1/workspace/ -name '*.fastq' 2>/dev/null | grep -v '1dsq' | grep -v 'combo' | xargs cat > $@

temp/minion_rna_basecalling/2/basecalling_2_done.txt: scripts/minion_rna/run_albacore_minion_rna_v2.sh
	mkdir -p `dirname $@`
	-rm $@
	bash $<
	touch $@

temp/minion_rna_basecalling/2/minion_rna2_1d_combo.fq: temp/minion_rna_basecalling/2/basecalling_2_done.txt
	find temp/minion_rna_basecalling/2/workspace/ -name '*.fastq' 2>/dev/null | grep -v '1dsq' | grep -v 'combo' | xargs cat > $@

temp/minion_rna_basecalling/1-2/minion_rna1-2_1d_combo.fq: temp/minion_rna_basecalling/1/minion_rna1_1d_combo.fq temp/minion_rna_basecalling/2/minion_rna2_1d_combo.fq
	mkdir -p `dirname $@`
	cat $^ > $@

temp/minion_rna_basecalling/3/basecalling_3_done.txt: scripts/minion_rna/run_albacore_minion_rna_v3.sh
	mkdir -p `dirname $@`
	-rm $@
	bash $<
	touch $@

temp/minion_rna_basecalling/3/minion_rna3_1d_combo.fq: temp/minion_rna_basecalling/3/basecalling_3_done.txt
	find temp/minion_rna_basecalling/3/workspace/ -name '*.fastq' 2>/dev/null | grep -v '1dsq' | grep -v 'combo' | xargs cat > $@

temp/minion_rna_basecalling/1-3/minion_rna1-3_1d_combo.fq: temp/minion_rna_basecalling/1/minion_rna1_1d_combo.fq temp/minion_rna_basecalling/2/minion_rna2_1d_combo.fq temp/minion_rna_basecalling/3/minion_rna3_1d_combo.fq 
	mkdir -p `dirname $@`
	cat $^ > $@

temp/minion_rna_basecalling/4/basecalling_4_done.txt: scripts/minion_rna/run_albacore_minion_rna_v4.sh
	mkdir -p `dirname $@`
	-rm $@
	bash $<
	touch $@

temp/minion_rna_basecalling/4/minion_rna4_1d_combo.fq: temp/minion_rna_basecalling/4/basecalling_4_done.txt
	find temp/minion_rna_basecalling/4/workspace/ -name '*.fastq' 2>/dev/null | grep -v '1dsq' | grep -v 'combo' | xargs cat > $@

temp/minion_rna_basecalling/1-4/minion_rna1-4_1d_combo.fq: temp/minion_rna_basecalling/1/minion_rna1_1d_combo.fq temp/minion_rna_basecalling/2/minion_rna2_1d_combo.fq temp/minion_rna_basecalling/3/minion_rna3_1d_combo.fq temp/minion_rna_basecalling/4/minion_rna4_1d_combo.fq
	mkdir -p `dirname $@`
	cat $^ > $@

################################################################################
################################################################################
#quality and length distributions for minion rna data (run 1):
minion_rna1_dist: temp/minion_rna_basecalling/1/dist/minion_rna1_1d_quals_mean.txt temp/minion_rna_basecalling/1/dist/minion_rna1_1d_quals_hist.pdf temp/minion_rna_basecalling/1/dist/minion_rna1_1d_lens_hist.pdf temp/minion_rna_basecalling/1/dist/minion_rna1_1d_lens_hist2.pdf temp/minion_rna_basecalling/1/dist/minion_rna1_1dsq_quals_mean.txt temp/minion_rna_basecalling/1/dist/minion_rna1_1dsq_quals_hist.pdf temp/minion_rna_basecalling/1/dist/minion_rna1_1dsq_lens_hist.pdf temp/minion_rna_basecalling/1/dist/minion_rna1_1dsq_lens_hist2.pdf temp/minion_rna_basecalling/1/dist/minion_rna1_1dsq_lens_hist3.pdf temp/minion_rna_basecalling/1/dist/minion_rna1_1d_lens_hist3.pdf

temp/minion_rna_basecalling/1/dist/minion_rna1_1d_quals.txt: scripts/util/calculate_average_read_quality.py temp/minion_rna_basecalling/1/minion_rna1_1d_combo.fq
	mkdir -p `dirname $@`
	-rm $@
	python $^ > $@
	touch $@
temp/minion_rna_basecalling/1/dist/minion_rna1_1d_quals_cpp_parallel.txt: temp/minion_rna_basecalling/1/minion_rna1_1d_combo.fq scripts/util/fq_qual_parallel.sh
	mkdir -p `dirname $@`
	cat $< | bash scripts/util/fq_qual_parallel.sh 16 > $@
temp/minion_rna_basecalling/1/dist/minion_rna1_1d_quals_cpp.txt: temp/minion_rna_basecalling/1/minion_rna1_1d_combo.fq
	mkdir -p `dirname $@`
	cat $< | fq_qual > $@
temp/minion_rna_basecalling/1/dist/minion_rna1_1d_quals_mean.txt: scripts/util/mean temp/minion_rna_basecalling/1/dist/minion_rna1_1d_quals.txt
	mkdir -p `dirname $@`
	-rm $@
	python $^ > $@
	touch $@
temp/minion_rna_basecalling/1/dist/minion_rna1_1d_quals_hist.pdf: scripts/util/hist temp/minion_rna_basecalling/1/dist/minion_rna1_1d_quals.txt
	mkdir -p `dirname $@`
	-rm $@
	Rscript $^ $@
	touch $@
temp/minion_rna_basecalling/1/dist/minion_rna1_1d_lens.txt: scripts/util/read_lengths.py temp/minion_rna_basecalling/1/minion_rna1_1d_combo.fq
	mkdir -p `dirname $@`
	-rm $@
	python $^ > $@
	touch $@
temp/minion_rna_basecalling/1/dist/minion_rna1_1d_lens_hist.pdf: scripts/util/hist temp/minion_rna_basecalling/1/dist/minion_rna1_1d_lens.txt
	mkdir -p `dirname $@`
	-rm $@
	Rscript $^ $@
	touch $@
temp/minion_rna_basecalling/1/dist/minion_rna1_1d_stats.txt: scripts/util/fqstatsqual.py temp/minion_rna_basecalling/minion_rna1_1d_combo.fq
	mkdir -p `dirname $@`
	-rm $@
	python $^ > $@
temp/minion_rna_basecalling/1/dist/minion_rna1_1d_lens_hist2.pdf: scripts/util/fq_read_hist temp/minion_rna_basecalling/1/dist/minion_rna1_1d_lens.txt
	mkdir -p `dirname $@`
	-rm $@
	Rscript $^ $@
	touch $@
temp/minion_rna_basecalling/1/dist/minion_rna1_1d_lens_hist3.pdf: scripts/util/fq_qual_hist_flex_top temp/minion_rna_basecalling/1/dist/minion_rna1_1d_lens.txt
	mkdir -p `dirname $@`
	-rm $@
	Rscript $^ $@
	touch $@

minion_rna2_dist: temp/minion_rna_basecalling/2/dist/minion_rna2_1d_quals_mean.txt temp/minion_rna_basecalling/2/dist/minion_rna2_1d_quals_hist.pdf temp/minion_rna_basecalling/2/dist/minion_rna2_1d_lens_hist.pdf temp/minion_rna_basecalling/2/dist/minion_rna2_1d_lens_hist2.pdf temp/minion_rna_basecalling/2/dist/minion_rna2_1d_lens_hist3.pdf

temp/minion_rna_basecalling/2/dist/minion_rna2_1d_quals.txt: scripts/util/calculate_average_read_quality.py temp/minion_rna_basecalling/2/minion_rna2_1d_combo.fq
	mkdir -p `dirname $@`
	-rm $@
	python $^ > $@
	touch $@
temp/minion_rna_basecalling/2/dist/minion_rna2_1d_quals_cpp_parallel.txt: temp/minion_rna_basecalling/2/minion_rna2_1d_combo.fq scripts/util/fq_qual_parallel.sh
	mkdir -p `dirname $@`
	cat $< | bash scripts/util/fq_qual_parallel.sh 16 > $@
temp/minion_rna_basecalling/2/dist/minion_rna2_1d_quals_cpp.txt: temp/minion_rna_basecalling/2/minion_rna2_1d_combo.fq
	mkdir -p `dirname $@`
	cat $< | fq_qual > $@
temp/minion_rna_basecalling/2/dist/minion_rna2_1d_quals_mean.txt: scripts/util/mean temp/minion_rna_basecalling/2/dist/minion_rna2_1d_quals.txt
	mkdir -p `dirname $@`
	-rm $@
	python $^ > $@
	touch $@
temp/minion_rna_basecalling/2/dist/minion_rna2_1d_quals_hist.pdf: scripts/util/hist temp/minion_rna_basecalling/2/dist/minion_rna2_1d_quals.txt
	mkdir -p `dirname $@`
	-rm $@
	Rscript $^ $@
	touch $@
temp/minion_rna_basecalling/2/dist/minion_rna2_1d_lens.txt: scripts/util/read_lengths.py temp/minion_rna_basecalling/2/minion_rna2_1d_combo.fq
	mkdir -p `dirname $@`
	-rm $@
	python $^ > $@
	touch $@
temp/minion_rna_basecalling/2/dist/minion_rna2_1d_lens_hist.pdf: scripts/util/hist temp/minion_rna_basecalling/2/dist/minion_rna2_1d_lens.txt
	mkdir -p `dirname $@`
	-rm $@
	Rscript $^ $@
	touch $@
temp/minion_rna_basecalling/2/dist/minion_rna2_1d_stats.txt: scripts/util/fqstatsqual.py temp/minion_rna_basecalling/minion_rna2_1d_combo.fq
	mkdir -p `dirname $@`
	-rm $@
	python $^ > $@
temp/minion_rna_basecalling/2/dist/minion_rna2_1d_lens_hist2.pdf: scripts/util/fq_read_hist temp/minion_rna_basecalling/2/dist/minion_rna2_1d_lens.txt
	mkdir -p `dirname $@`
	-rm $@
	Rscript $^ $@
	touch $@
temp/minion_rna_basecalling/2/dist/minion_rna2_1d_lens_hist3.pdf: scripts/util/fq_qual_hist_flex_top temp/minion_rna_basecalling/2/dist/minion_rna2_1d_lens.txt
	mkdir -p `dirname $@`
	-rm $@
	Rscript $^ $@
	touch $@

minion_rna1-2_dist: temp/minion_rna_basecalling/1-2/dist/minion_rna1-2_1d_quals_mean.txt temp/minion_rna_basecalling/1-2/dist/minion_rna1-2_1d_quals_hist.pdf temp/minion_rna_basecalling/1-2/dist/minion_rna1-2_1d_lens_hist.pdf temp/minion_rna_basecalling/1-2/dist/minion_rna1-2_1d_lens_hist1-2.pdf temp/minion_rna_basecalling/1-2/dist/minion_rna1-2_1d_lens_hist3.pdf

temp/minion_rna_basecalling/1-2/dist/minion_rna1-2_1d_quals.txt: scripts/util/calculate_average_read_quality.py temp/minion_rna_basecalling/1-2/minion_rna1-2_1d_combo.fq
	mkdir -p `dirname $@`
	-rm $@
	python $^ > $@
	touch $@
temp/minion_rna_basecalling/1-2/dist/minion_rna1-2_1d_quals_cpp_parallel.txt: temp/minion_rna_basecalling/1-2/minion_rna1-2_1d_combo.fq scripts/util/fq_qual_parallel.sh
	mkdir -p `dirname $@`
	cat $< | bash scripts/util/fq_qual_parallel.sh 16 > $@
temp/minion_rna_basecalling/1-2/dist/minion_rna1-2_1d_quals_cpp.txt: temp/minion_rna_basecalling/1-2/minion_rna1-2_1d_combo.fq
	mkdir -p `dirname $@`
	cat $< | fq_qual > $@
temp/minion_rna_basecalling/1-2/dist/minion_rna1-2_1d_quals_mean.txt: scripts/util/mean temp/minion_rna_basecalling/1-2/dist/minion_rna1-2_1d_quals_cpp_parallel.txt
	mkdir -p `dirname $@`
	-rm $@
	python $^ > $@
	touch $@
temp/minion_rna_basecalling/1-2/dist/minion_rna1-2_1d_quals_hist.pdf: scripts/util/hist temp/minion_rna_basecalling/1-2/dist/minion_rna1-2_1d_quals_cpp_parallel.txt
	mkdir -p `dirname $@`
	-rm $@
	Rscript $^ $@
	touch $@
temp/minion_rna_basecalling/1-2/dist/minion_rna1-2_1d_lens.txt: scripts/util/read_lengths.py temp/minion_rna_basecalling/1-2/minion_rna1-2_1d_combo.fq
	mkdir -p `dirname $@`
	-rm $@
	python $^ > $@
	touch $@
temp/minion_rna_basecalling/1-2/dist/minion_rna1-2_1d_lens_hist.pdf: scripts/util/hist temp/minion_rna_basecalling/1-2/dist/minion_rna1-2_1d_lens.txt
	mkdir -p `dirname $@`
	-rm $@
	Rscript $^ $@
	touch $@
temp/minion_rna_basecalling/1-2/dist/minion_rna1-2_1d_stats.txt: scripts/util/fqstatsqual.py temp/minion_rna_basecalling/minion_rna1-2_1d_combo.fq
	mkdir -p `dirname $@`
	-rm $@
	python $^ > $@
temp/minion_rna_basecalling/1-2/dist/minion_rna1-2_1d_lens_hist1-2.pdf: scripts/util/fq_read_hist temp/minion_rna_basecalling/1-2/dist/minion_rna1-2_1d_lens.txt
	mkdir -p `dirname $@`
	-rm $@
	Rscript $^ $@
	touch $@
temp/minion_rna_basecalling/1-2/dist/minion_rna1-2_1d_lens_hist3.pdf: scripts/util/fq_qual_hist_flex_top temp/minion_rna_basecalling/1-2/dist/minion_rna1-2_1d_lens.txt
	mkdir -p `dirname $@`
	-rm $@
	Rscript $^ $@
	touch $@

minion_rna3_dist: temp/minion_rna_basecalling/3/dist/minion_rna3_1d_quals_mean.txt temp/minion_rna_basecalling/3/dist/minion_rna3_1d_quals_hist.pdf temp/minion_rna_basecalling/3/dist/minion_rna3_1d_lens_hist.pdf temp/minion_rna_basecalling/3/dist/minion_rna3_1d_lens_hist2.pdf temp/minion_rna_basecalling/3/dist/minion_rna3_1d_lens_hist3.pdf

temp/minion_rna_basecalling/3/dist/minion_rna3_1d_quals.txt: scripts/util/calculate_average_read_quality.py temp/minion_rna_basecalling/3/minion_rna3_1d_combo.fq
	mkdir -p `dirname $@`
	-rm $@
	python $^ > $@
	touch $@
temp/minion_rna_basecalling/3/dist/minion_rna3_1d_quals_cpp_parallel.txt: temp/minion_rna_basecalling/3/minion_rna3_1d_combo.fq scripts/util/fq_qual_parallel.sh
	mkdir -p `dirname $@`
	cat $< | bash scripts/util/fq_qual_parallel.sh 16 > $@
temp/minion_rna_basecalling/3/dist/minion_rna3_1d_quals_cpp.txt: temp/minion_rna_basecalling/3/minion_rna3_1d_combo.fq
	mkdir -p `dirname $@`
	cat $< | fq_qual > $@
temp/minion_rna_basecalling/3/dist/minion_rna3_1d_quals_mean.txt: scripts/util/mean temp/minion_rna_basecalling/3/dist/minion_rna3_1d_quals.txt
	mkdir -p `dirname $@`
	-rm $@
	python $^ > $@
	touch $@
temp/minion_rna_basecalling/3/dist/minion_rna3_1d_quals_hist.pdf: scripts/util/hist temp/minion_rna_basecalling/3/dist/minion_rna3_1d_quals.txt
	mkdir -p `dirname $@`
	-rm $@
	Rscript $^ $@
	touch $@
temp/minion_rna_basecalling/3/dist/minion_rna3_1d_lens.txt: scripts/util/read_lengths.py temp/minion_rna_basecalling/3/minion_rna3_1d_combo.fq
	mkdir -p `dirname $@`
	-rm $@
	python $^ > $@
	touch $@
temp/minion_rna_basecalling/3/dist/minion_rna3_1d_lens_hist.pdf: scripts/util/hist temp/minion_rna_basecalling/3/dist/minion_rna3_1d_lens.txt
	mkdir -p `dirname $@`
	-rm $@
	Rscript $^ $@
	touch $@
temp/minion_rna_basecalling/3/dist/minion_rna3_1d_stats.txt: scripts/util/fqstatsqual.py temp/minion_rna_basecalling/minion_rna3_1d_combo.fq
	mkdir -p `dirname $@`
	-rm $@
	python $^ > $@
temp/minion_rna_basecalling/3/dist/minion_rna3_1d_lens_hist2.pdf: scripts/util/fq_read_hist temp/minion_rna_basecalling/3/dist/minion_rna3_1d_lens.txt
	mkdir -p `dirname $@`
	-rm $@
	Rscript $^ $@
	touch $@
temp/minion_rna_basecalling/3/dist/minion_rna3_1d_lens_hist3.pdf: scripts/util/fq_qual_hist_flex_top temp/minion_rna_basecalling/3/dist/minion_rna3_1d_lens.txt
	mkdir -p `dirname $@`
	-rm $@
	Rscript $^ $@
	touch $@

minion_rna1-3_dist: temp/minion_rna_basecalling/1-3/dist/minion_rna1-3_1d_quals_mean.txt temp/minion_rna_basecalling/1-3/dist/minion_rna1-3_1d_quals_hist.pdf temp/minion_rna_basecalling/1-3/dist/minion_rna1-3_1d_lens_hist.pdf temp/minion_rna_basecalling/1-3/dist/minion_rna1-3_1d_lens_hist2.pdf temp/minion_rna_basecalling/1-3/dist/minion_rna1-3_1d_lens_hist3.pdf

temp/minion_rna_basecalling/1-3/dist/minion_rna1-3_1d_quals.txt: scripts/util/calculate_average_read_quality.py temp/minion_rna_basecalling/1-3/minion_rna1-3_1d_combo.fq
	mkdir -p `dirname $@`
	-rm $@
	python $^ > $@
	touch $@
temp/minion_rna_basecalling/1-3/dist/minion_rna1-3_1d_quals_cpp_parallel.txt: temp/minion_rna_basecalling/1-3/minion_rna1-3_1d_combo.fq scripts/util/fq_qual_parallel.sh
	mkdir -p `dirname $@`
	cat $< | bash scripts/util/fq_qual_parallel.sh 16 > $@
temp/minion_rna_basecalling/1-3/dist/minion_rna1-3_1d_quals_cpp.txt: temp/minion_rna_basecalling/1-3/minion_rna1-3_1d_combo.fq
	mkdir -p `dirname $@`
	cat $< | fq_qual > $@
temp/minion_rna_basecalling/1-3/dist/minion_rna1-3_1d_quals_mean.txt: scripts/util/mean temp/minion_rna_basecalling/1-3/dist/minion_rna1-3_1d_quals_cpp_parallel.txt
	mkdir -p `dirname $@`
	-rm $@
	python $^ > $@
	touch $@
temp/minion_rna_basecalling/1-3/dist/minion_rna1-3_1d_quals_hist.pdf: scripts/util/hist temp/minion_rna_basecalling/1-3/dist/minion_rna1-3_1d_quals_cpp_parallel.txt
	mkdir -p `dirname $@`
	-rm $@
	Rscript $^ $@
	touch $@
temp/minion_rna_basecalling/1-3/dist/minion_rna1-3_1d_lens.txt: scripts/util/read_lengths.py temp/minion_rna_basecalling/1-3/minion_rna1-3_1d_combo.fq
	mkdir -p `dirname $@`
	-rm $@
	python $^ > $@
	touch $@
temp/minion_rna_basecalling/1-3/dist/minion_rna1-3_1d_lens_hist.pdf: scripts/util/hist temp/minion_rna_basecalling/1-3/dist/minion_rna1-3_1d_lens.txt
	mkdir -p `dirname $@`
	-rm $@
	Rscript $^ $@
	touch $@
temp/minion_rna_basecalling/1-3/dist/minion_rna1-3_1d_stats.txt: scripts/util/fqstatsqual.py temp/minion_rna_basecalling/minion_rna1-3_1d_combo.fq
	mkdir -p `dirname $@`
	-rm $@
	python $^ > $@
temp/minion_rna_basecalling/1-3/dist/minion_rna1-3_1d_lens_hist2.pdf: scripts/util/fq_read_hist temp/minion_rna_basecalling/1-3/dist/minion_rna1-3_1d_lens.txt
	mkdir -p `dirname $@`
	-rm $@
	Rscript $^ $@
	touch $@
temp/minion_rna_basecalling/1-3/dist/minion_rna1-3_1d_lens_hist3.pdf: scripts/util/fq_qual_hist_flex_top temp/minion_rna_basecalling/1-3/dist/minion_rna1-3_1d_lens.txt
	mkdir -p `dirname $@`
	-rm $@
	Rscript $^ $@
	touch $@

minion_rna4_dist: temp/minion_rna_basecalling/4/dist/minion_rna4_1d_quals_mean.txt temp/minion_rna_basecalling/4/dist/minion_rna4_1d_quals_hist.pdf temp/minion_rna_basecalling/4/dist/minion_rna4_1d_lens_hist.pdf temp/minion_rna_basecalling/4/dist/minion_rna4_1d_lens_hist2.pdf temp/minion_rna_basecalling/4/dist/minion_rna4_1d_lens_hist4.pdf

temp/minion_rna_basecalling/4/dist/minion_rna4_1d_quals.txt: scripts/util/calculate_average_read_quality.py temp/minion_rna_basecalling/4/minion_rna4_1d_combo.fq
	mkdir -p `dirname $@`
	-rm $@
	python $^ > $@
	touch $@
temp/minion_rna_basecalling/4/dist/minion_rna4_1d_quals_cpp_parallel.txt: temp/minion_rna_basecalling/4/minion_rna4_1d_combo.fq scripts/util/fq_qual_parallel.sh
	mkdir -p `dirname $@`
	cat $< | bash scripts/util/fq_qual_parallel.sh 16 > $@
temp/minion_rna_basecalling/4/dist/minion_rna4_1d_quals_cpp.txt: temp/minion_rna_basecalling/4/minion_rna4_1d_combo.fq
	mkdir -p `dirname $@`
	cat $< | fq_qual > $@
temp/minion_rna_basecalling/4/dist/minion_rna4_1d_quals_mean.txt: scripts/util/mean temp/minion_rna_basecalling/4/dist/minion_rna4_1d_quals.txt
	mkdir -p `dirname $@`
	-rm $@
	python $^ > $@
	touch $@
temp/minion_rna_basecalling/4/dist/minion_rna4_1d_quals_hist.pdf: scripts/util/hist temp/minion_rna_basecalling/4/dist/minion_rna4_1d_quals.txt
	mkdir -p `dirname $@`
	-rm $@
	Rscript $^ $@
	touch $@
temp/minion_rna_basecalling/4/dist/minion_rna4_1d_lens.txt: scripts/util/read_lengths.py temp/minion_rna_basecalling/4/minion_rna4_1d_combo.fq
	mkdir -p `dirname $@`
	-rm $@
	python $^ > $@
	touch $@
temp/minion_rna_basecalling/4/dist/minion_rna4_1d_lens_hist.pdf: scripts/util/hist temp/minion_rna_basecalling/4/dist/minion_rna4_1d_lens.txt
	mkdir -p `dirname $@`
	-rm $@
	Rscript $^ $@
	touch $@
temp/minion_rna_basecalling/4/dist/minion_rna4_1d_stats.txt: scripts/util/fqstatsqual.py temp/minion_rna_basecalling/minion_rna4_1d_combo.fq
	mkdir -p `dirname $@`
	-rm $@
	python $^ > $@
temp/minion_rna_basecalling/4/dist/minion_rna4_1d_lens_hist2.pdf: scripts/util/fq_read_hist temp/minion_rna_basecalling/4/dist/minion_rna4_1d_lens.txt
	mkdir -p `dirname $@`
	-rm $@
	Rscript $^ $@
	touch $@
temp/minion_rna_basecalling/4/dist/minion_rna4_1d_lens_hist4.pdf: scripts/util/fq_qual_hist_flex_top temp/minion_rna_basecalling/4/dist/minion_rna4_1d_lens.txt
	mkdir -p `dirname $@`
	-rm $@
	Rscript $^ $@
	touch $@

minion_rna1-4_dist: temp/minion_rna_basecalling/1-4/dist/minion_rna1-4_1d_quals_mean.txt temp/minion_rna_basecalling/1-4/dist/minion_rna1-4_1d_quals_hist.pdf temp/minion_rna_basecalling/1-4/dist/minion_rna1-4_1d_lens_hist.pdf temp/minion_rna_basecalling/1-4/dist/minion_rna1-4_1d_lens_hist2.pdf temp/minion_rna_basecalling/1-4/dist/minion_rna1-4_1d_lens_hist4.pdf

temp/minion_rna_basecalling/1-4/dist/minion_rna1-4_1d_quals.txt: scripts/util/calculate_average_read_quality.py temp/minion_rna_basecalling/1-4/minion_rna1-4_1d_combo.fq
	mkdir -p `dirname $@`
	-rm $@
	python $^ > $@
	touch $@
temp/minion_rna_basecalling/1-4/dist/minion_rna1-4_1d_quals_cpp_parallel.txt: temp/minion_rna_basecalling/1-4/minion_rna1-4_1d_combo.fq scripts/util/fq_qual_parallel.sh
	mkdir -p `dirname $@`
	cat $< | bash scripts/util/fq_qual_parallel.sh 16 > $@
temp/minion_rna_basecalling/1-4/dist/minion_rna1-4_1d_quals_cpp.txt: temp/minion_rna_basecalling/1-4/minion_rna1-4_1d_combo.fq
	mkdir -p `dirname $@`
	cat $< | fq_qual > $@
temp/minion_rna_basecalling/1-4/dist/minion_rna1-4_1d_quals_mean.txt: scripts/util/mean temp/minion_rna_basecalling/1-4/dist/minion_rna1-4_1d_quals_cpp_parallel.txt
	mkdir -p `dirname $@`
	-rm $@
	python $^ > $@
	touch $@
temp/minion_rna_basecalling/1-4/dist/minion_rna1-4_1d_quals_hist.pdf: scripts/util/hist temp/minion_rna_basecalling/1-4/dist/minion_rna1-4_1d_quals_cpp_parallel.txt
	mkdir -p `dirname $@`
	-rm $@
	Rscript $^ $@
	touch $@
temp/minion_rna_basecalling/1-4/dist/minion_rna1-4_1d_lens.txt: scripts/util/read_lengths.py temp/minion_rna_basecalling/1-4/minion_rna1-4_1d_combo.fq
	mkdir -p `dirname $@`
	-rm $@
	python $^ > $@
	touch $@
temp/minion_rna_basecalling/1-4/dist/minion_rna1-4_1d_lens_hist.pdf: scripts/util/hist temp/minion_rna_basecalling/1-4/dist/minion_rna1-4_1d_lens.txt
	mkdir -p `dirname $@`
	-rm $@
	Rscript $^ $@
	touch $@
temp/minion_rna_basecalling/1-4/dist/minion_rna1-4_1d_stats.txt: scripts/util/fqstatsqual.py temp/minion_rna_basecalling/minion_rna1-4_1d_combo.fq
	mkdir -p `dirname $@`
	-rm $@
	python $^ > $@
temp/minion_rna_basecalling/1-4/dist/minion_rna1-4_1d_lens_hist2.pdf: scripts/util/fq_read_hist temp/minion_rna_basecalling/1-4/dist/minion_rna1-4_1d_lens.txt
	mkdir -p `dirname $@`
	-rm $@
	Rscript $^ $@
	touch $@
temp/minion_rna_basecalling/1-4/dist/minion_rna1-4_1d_lens_hist4.pdf: scripts/util/fq_qual_hist_flex_top temp/minion_rna_basecalling/1-4/dist/minion_rna1-4_1d_lens.txt
	mkdir -p `dirname $@`
	-rm $@
	Rscript $^ $@
	touch $@

################################################################################
################################################################################
#align mrna sequences to genome:

align_mrna: temp/minion_rna_alignment/1/mrna_align.sam temp/minion_rna_alignment/1/mrna_align_sorted.bam temp/minion_rna_alignment/2/mrna_align_sorted.bam temp/minion_rna_alignment/1-2/mrna_align_sorted.bam temp/minion_rna_alignment/4/mrna_align_sorted.bam temp/minion_rna_alignment/1-4/mrna_align_sorted.bam temp/minion_rna_alignment/3/mrna_align_sorted.bam

#v1. align first mrna sequences to incomplete genome using graphmap standard settings
temp/minion_rna_alignment/1/mrna_align.sam: temp/minion_rna_basecalling/1/minion_rna1_1d_combo.fq temp/canu/v1/canu_done.txt
	mkdir -p `dirname $@`
	graphmap align -r temp/canu/v1/louse_canu_v1.contigs.fasta -d $< -o $@
temp/minion_rna_alignment/1/mrna_align.bam: temp/minion_rna_alignment/1/mrna_align.sam
	mkdir -p `dirname $@`
	samtools view -S -b $< > $@
temp/minion_rna_alignment/1/mrna_align_sorted.bam: temp/minion_rna_alignment/1/mrna_align.bam
	mkdir -p `dirname $@`
	samtools sort $< temp/minion_rna_alignment/1/mrna_align_sorted
temp/minion_rna_alignment/1/mrna_align_md.sam: temp/minion_rna_alignment/1/mrna_align.sam temp/canu/v1/canu_done.txt
	mkdir -p `dirname $@`
	samtools fillmd -S $< temp/canu/v1/louse_canu_v1.contigs.fasta > $@ 2>temp.txt

temp/minion_rna_alignment/2/mrna_align.sam: temp/minion_rna_basecalling/2/minion_rna2_1d_combo.fq temp/canu/v1/canu_done.txt
	mkdir -p `dirname $@`
	graphmap align -t 16 -r temp/canu/v1/louse_canu_v1.contigs.fasta -d $< -o $@
temp/minion_rna_alignment/2/mrna_align.bam: temp/minion_rna_alignment/2/mrna_align.sam
	mkdir -p `dirname $@`
	samtools view -S -b $< > $@
temp/minion_rna_alignment/2/mrna_align_sorted.bam: temp/minion_rna_alignment/2/mrna_align.bam
	mkdir -p `dirname $@`
	samtools sort $< temp/minion_rna_alignment/2/mrna_align_sorted
temp/minion_rna_alignment/2/mrna_align_md.sam: temp/minion_rna_alignment/2/mrna_align.sam temp/canu/v1/canu_done.txt
	mkdir -p `dirname $@`
	samtools fillmd -S $< temp/canu/v1/louse_canu_v1.contigs.fasta > $@ 2>temp.txt

temp/minion_rna_alignment/1-2/mrna_align.sam: temp/minion_rna_basecalling/1-2/minion_rna1-2_1d_combo.fq temp/canu/v1/canu_done.txt
	mkdir -p `dirname $@`
	graphmap align -t 16 -r temp/canu/v1/louse_canu_v1.contigs.fasta -d $< -o $@
temp/minion_rna_alignment/1-2/mrna_align.bam: temp/minion_rna_alignment/1-2/mrna_align.sam
	mkdir -p `dirname $@`
	samtools view -S -b $< > $@
temp/minion_rna_alignment/1-2/mrna_align_sorted.bam: temp/minion_rna_alignment/1-2/mrna_align.bam
	mkdir -p `dirname $@`
	samtools sort $< temp/minion_rna_alignment/1-2/mrna_align_sorted
temp/minion_rna_alignment/1-2/mrna_align_md.sam: temp/minion_rna_alignment/1-2/mrna_align.sam temp/canu/v1/canu_done.txt
	mkdir -p `dirname $@`
	samtools fillmd -S $< temp/canu/v1/louse_canu_v1.contigs.fasta > $@ 2>temp.txt

temp/minion_rna_alignment/3/mrna_align.sam: temp/minion_rna_basecalling/3/minion_rna3_1d_combo.fq temp/canu/v1/canu_done.txt
	mkdir -p `dirname $@`
	graphmap align -t 16 -r temp/canu/v1/louse_canu_v1.contigs.fasta -d $< -o $@
temp/minion_rna_alignment/3/mrna_align.bam: temp/minion_rna_alignment/3/mrna_align.sam
	mkdir -p `dirname $@`
	samtools view -S -b $< > $@
temp/minion_rna_alignment/3/mrna_align_sorted.bam: temp/minion_rna_alignment/3/mrna_align.bam
	mkdir -p `dirname $@`
	samtools sort $< temp/minion_rna_alignment/3/mrna_align_sorted
temp/minion_rna_alignment/3/mrna_align_md.sam: temp/minion_rna_alignment/3/mrna_align.sam temp/canu/v1/canu_done.txt
	mkdir -p `dirname $@`
	samtools fillmd -S $< temp/canu/v1/louse_canu_v1.contigs.fasta > $@ 2>temp.txt

temp/minion_rna_alignment/4/mrna_align.sam: temp/minion_rna_basecalling/4/minion_rna4_1d_combo.fq temp/canu/v1/canu_done.txt
	mkdir -p `dirname $@`
	graphmap align -t 16 -r temp/canu/v1/louse_canu_v1.contigs.fasta -d $< -o $@
temp/minion_rna_alignment/4/mrna_align.bam: temp/minion_rna_alignment/4/mrna_align.sam
	mkdir -p `dirname $@`
	samtools view -S -b $< > $@
temp/minion_rna_alignment/4/mrna_align_sorted.bam: temp/minion_rna_alignment/4/mrna_align.bam
	mkdir -p `dirname $@`
	samtools sort $< temp/minion_rna_alignment/4/mrna_align_sorted
temp/minion_rna_alignment/4/mrna_align_md.sam: temp/minion_rna_alignment/4/mrna_align.sam temp/canu/v1/canu_done.txt
	mkdir -p `dirname $@`
	samtools fillmd -S $< temp/canu/v1/louse_canu_v1.contigs.fasta > $@ 2>temp.txt

temp/minion_rna_alignment/1-4/mrna_align.sam: temp/minion_rna_basecalling/1-4/minion_rna1-4_1d_combo.fq temp/canu/v1/canu_done.txt
	mkdir -p `dirname $@`
	graphmap align -t 16 -r temp/canu/v1/louse_canu_v1.contigs.fasta -d $< -o $@
temp/minion_rna_alignment/1-4/mrna_align.bam: temp/minion_rna_alignment/1-4/mrna_align.sam
	mkdir -p `dirname $@`
	samtools view -S -b $< > $@
temp/minion_rna_alignment/1-4/mrna_align_sorted.bam: temp/minion_rna_alignment/1-4/mrna_align.bam
	mkdir -p `dirname $@`
	samtools sort $< temp/minion_rna_alignment/1-4/mrna_align_sorted
temp/minion_rna_alignment/1-4/mrna_align_md.sam: temp/minion_rna_alignment/1-4/mrna_align.sam temp/canu/v1/canu_done.txt
	mkdir -p `dirname $@`
	samtools fillmd -S $< temp/canu/v1/louse_canu_v1.contigs.fasta > $@ 2>temp.txt

################################################################################
################################################################################
#DBG2OLC assemblies:

########################################
#first dbg2olc assembly, using all data from 1st cell and 1d data from 2nd cell


########################################
#second dbg2olc assembly, using all data from 1st and 2nd cells

dbg2olc_v2: temp/dbg2olc/v2/dbg2olc_done.txt

temp/dbg2olc/v2/dbg2olc_done.txt: scripts/dbg2olc/full_make_v2/Makefile temp/minion_basecalling/combo_12/minion_12_combo.fq raw_data/previous_assemblies/taxon_filtered_louse/ALM_F2Male_MDS349_CLCassembly.fasta
	mkdir -p `dirname $@`
	-rm $@
	rsync -avP $< `dirname $@`
	cd `dirname $@` && make
	touch $@

########################################
#third dbg2olc assembly, using all data from 1st and 2nd cells and using a different dbg assembly: the allpaths assembly

dbg2olc_v3: temp/dbg2olc/v3/dbg2olc_done.txt

temp/dbg2olc/v3/dbg2olc_done.txt: scripts/dbg2olc/full_make_v3/Makefile temp/minion_basecalling/combo_12/minion_12_combo.fq raw_data/previous_assemblies/allpaths_unfiltered/DATA/RUN_062415/ASSEMBLIES/test/final.contigs.fasta
	mkdir -p `dirname $@`
	-rm $@
	rsync -avP $< `dirname $@`
	cd `dirname $@` && make
	touch $@

########################################
#fourth assembly: same as second assembly, but using all fasta files (no fastq files, even for raw data)

temp/minion_basecalling/combo_12/minion_12_combo.fa: temp/minion_basecalling/combo_12/minion_12_combo.fq
	mkdir -p `dirname $@`
	-rm $@
	cat $< | fq2fa > $@

dbg2olc_v4: temp/dbg2olc/v4/dbg2olc_done.txt

temp/dbg2olc/v4/dbg2olc_done.txt: scripts/dbg2olc/full_make_v4/Makefile temp/minion_basecalling/combo_12/minion_12_combo.fq raw_data/previous_assemblies/taxon_filtered_louse/ALM_F2Male_MDS349_CLCassembly.fasta
	mkdir -p `dirname $@`
	-rm $@
	rsync -avP $< `dirname $@`
	cd `dirname $@` && make
	touch $@

########################################
#fifth assembly: same as third assembly, but using all fasta files (no fastq files, even for raw data)

dbg2olc_v5: temp/dbg2olc/v5/dbg2olc_done.txt

temp/dbg2olc/v5/dbg2olc_done.txt: scripts/dbg2olc/full_make_v5/Makefile temp/minion_basecalling/combo_12/minion_12_combo.fq raw_data/previous_assemblies/allpaths_unfiltered/DATA/RUN_062415/ASSEMBLIES/test/final.contigs.fasta
	mkdir -p `dirname $@`
	-rm $@
	rsync -avP $< `dirname $@`
	cd `dirname $@` && make
	touch $@

########################################
dbg2olc_v6: temp/dbg2olc/v6/dbg2olc_done.txt

temp/dbg2olc/v6/dbg2olc_done.txt: scripts/dbg2olc/full_make_v6/Makefile temp/minion_basecalling/combo_12345/minion12345_full_combo.fa raw_data/previous_assemblies/taxon_filtered_louse/ALM_F2Male_MDS349_CLCassembly.fasta
	mkdir -p `dirname $@`
	-rm $@
	rsync -avP $< `dirname $@`
	cd `dirname $@` && make
	touch $@

########################################
dbg2olc_v7: temp/dbg2olc/v7/dbg2olc_done.txt

temp/dbg2olc/v7/dbg2olc_done.txt: scripts/dbg2olc/full_make_v7/Makefile temp/minion_basecalling/combo_12345/minion12345_full_combo.fa raw_data/previous_assemblies/taxon_filtered_louse/ALM_F2Male_MDS349_CLCassembly.fasta
	mkdir -p `dirname $@`
	-rm $@
	rsync -avP $< `dirname $@`
	cd `dirname $@` && make
	touch $@

########################################
cleaned_clc_assembly: temp/cleaned_clc_assembly/clc_cleaned_assembly.fa

temp/cleaned_clc_assembly/clc_cleaned_assembly.fa: /data1/jbrown/louse_project/raw_data/previous_assemblies/taxon_filtered_louse/ALM_F2Male_MDS349_CLCassembly.fasta
	mkdir -p `dirname $@`
	-rm $@
	cat $< | bioawk -c fastx 'length($$seq)>5{print ">"$$name; print $$seq}' > $@

dbg2olc_v8: temp/dbg2olc/v8/dbg2olc_done.txt

temp/dbg2olc/v8/dbg2olc_done.txt: scripts/dbg2olc/full_make_v8/Makefile temp/minion_basecalling/combo_12345/minion12345_full_combo.fa raw_data/previous_assemblies/taxon_filtered_louse/ALM_F2Male_MDS349_CLCassembly.fasta temp/cleaned_clc_assembly/clc_cleaned_assembly.fa
	mkdir -p `dirname $@`
	-rm $@
	rsync -avP $< `dirname $@`
	cd `dirname $@` && make
	touch $@

########################################
#first attempt at canu assembly using all data from 1st and 2nd cells:

canu_v1: temp/canu/v1/canu_done.txt temp/canu/v1/canu_cumcov_plot.pdf plots/canu/v1/canu_cumcov_plot.pdf plots/canu/v1/canu_cumcov_multiplot.pdf

temp/canu/v1/canu_done.txt: temp/minion_basecalling/combo_12/minion_12_combo.fq
	mkdir -p `dirname $@`
	-rm $@
	canu -p louse_canu_v1 -d temp/canu/v1 -s scripts/canu/v1/specfile.txt genomeSize=220m -nanopore-raw temp/minion_basecalling/combo_12/minion_12_combo.fq
	touch $@

canu_v1_copy: temp/canu/v1_copy/canu_done.txt

temp/canu/v1_copy/canu_done.txt: temp/minion_basecalling/combo_12/minion_12_combo.fq
	mkdir -p `dirname $@`
	-rm $@
	canu -p louse_canu_v1 -d temp/canu/v1_copy -s scripts/canu/v1/specfile.txt genomeSize=220m -nanopore-raw temp/minion_basecalling/combo_12/minion_12_combo.fq
	touch $@

temp/canu/v1/canu_v1_lengths.txt: scripts/util/read_lengths.py temp/canu/v1/canu_done.txt
	mkdir -p `dirname $@`
	-rm $@
	python $< temp/canu/v1/louse_canu_v1.contigs.fasta > $@
	touch $@
temp/canu/v1/canu_cumcov_plot.pdf: scripts/util/cumcov_plot.R temp/canu/v1/canu_v1_lengths.txt
	mkdir -p `dirname $@`
	-rm $@
	Rscript $^ "Cumulative coverage of Canu assembly v1" $@
	touch $@
plots/canu/v1/canu_cumcov_plot.pdf: temp/canu/v1/canu_cumcov_plot.pdf
	mkdir -p `dirname $@`
	-rm $@
	rsync -avP $< $@
	touch $@

temp/canu/v1/clc_v1_lengths.txt: scripts/util/read_lengths.py raw_data/previous_assemblies/taxon_filtered_louse/ALM_F2Male_MDS349_CLCassembly.fasta
	mkdir -p `dirname $@`
	-rm $@
	python $< raw_data/previous_assemblies/taxon_filtered_louse/ALM_F2Male_MDS349_CLCassembly.fasta > $@
	touch $@
temp/canu/v1/canu_cumcov_multiplot.pdf: scripts/util/cumcov_plot_multiple.R temp/canu/v1/canu_v1_lengths.txt temp/canu/v1/clc_v1_lengths.txt
	mkdir -p `dirname $@`
	-rm $@
	Rscript $^ "Cumulative coverage of various assemblies" $@
	touch $@
plots/canu/v1/canu_cumcov_multiplot.pdf: temp/canu/v1/canu_cumcov_multiplot.pdf
	mkdir -p `dirname $@`
	-rm $@
	rsync -avP $< $@
	touch $@

########################################
#second canu attempt, with all data:
canu_v2: temp/canu/v2/canu_done.txt temp/canu/v2/canu_cumcov_plot.pdf plots/canu/v2/canu_cumcov_plot.pdf plots/canu/v2/canu_cumcov_multiplot.pdf

temp/canu/v2/canu_done.txt: temp/minion_basecalling/combo_12345/minion12345_full_combo.fq
	mkdir -p `dirname $@`
	-rm $@
	canu -p louse_canu_v2 -d temp/canu/v2 -s scripts/canu/v2/specfile.txt genomeSize=220m -nanopore-raw temp/minion_basecalling/combo_12345/minion12345_full_combo.fq
	touch $@

canu_v2_copy: temp/canu/v2_copy/canu_done.txt

temp/canu/v2_extra_run/canu_done.txt: temp/minion_basecalling/combo_12345/minion12345_full_combo.fq
	mkdir -p `dirname $@`
	-rm $@
	canu -p louse_canu_v2 -d temp/canu/v2_extra_run -s scripts/canu/v2/specfile.txt genomeSize=220m -nanopore-raw temp/minion_basecalling/combo_12345/minion12345_full_combo.fq
	touch $@

temp/canu/v2_copy/canu_done.txt: temp/canu/v2/canu_done.txt
	mkdir -p `dirname $@`
	-rm $@
	rsync -avP `dirname $<`/ `dirname $@`/
	touch $@

temp/canu/v2/canu_v2_lengths.txt: scripts/util/read_lengths.py temp/canu/v2/canu_done.txt
	mkdir -p `dirname $@`
	-rm $@
	python $< temp/canu/v2/louse_canu_v2.contigs.fasta > $@
	touch $@
temp/canu/v2/canu_cumcov_plot.pdf: scripts/util/cumcov_plot.R temp/canu/v2/canu_v2_lengths.txt
	mkdir -p `dirname $@`
	-rm $@
	Rscript $^ "Cumulative coverage of Canu assembly v2" $@
	touch $@
plots/canu/v2/canu_cumcov_plot.pdf: temp/canu/v2/canu_cumcov_plot.pdf
	mkdir -p `dirname $@`
	-rm $@
	rsync -avP $< $@
	touch $@

temp/canu/v2/clc_v2_lengths.txt: scripts/util/read_lengths.py raw_data/previous_assemblies/taxon_filtered_louse/ALM_F2Male_MDS349_CLCassembly.fasta
	mkdir -p `dirname $@`
	-rm $@
	python $< raw_data/previous_assemblies/taxon_filtered_louse/ALM_F2Male_MDS349_CLCassembly.fasta > $@
	touch $@
temp/canu/v2/canu_cumcov_multiplot.pdf: scripts/util/cumcov_plot_multiple_v2.R temp/canu/v2/canu_v2_lengths.txt temp/canu/v1/canu_v1_lengths.txt temp/canu/v2/clc_v2_lengths.txt
	mkdir -p `dirname $@`
	-rm $@
	Rscript $^ "Cumulative coverage of various assemblies" $@
	touch $@
plots/canu/v2/canu_cumcov_multiplot.pdf: temp/canu/v2/canu_cumcov_multiplot.pdf
	mkdir -p `dirname $@`
	-rm $@
	rsync -avP $< $@
	touch $@

########################################
#third canu attempt, with all data

canu_v3: temp/canu/v3/canu_done.txt temp/canu/v3/canu_cumcov_plot.pdf plots/canu/v3/canu_cumcov_plot.pdf plots/canu/v3/canu_cumcov_multiplot.pdf

temp/canu/v3/canu_done.txt: /data1/jbrown/louse_project/temp/minion_basecalling/combo_12345/26x_full_combo_12345.fq
	mkdir -p `dirname $@`
	-rm $@
	canu -p louse_canu_v3 -d temp/canu/v3 -s scripts/canu/v3/specfile.txt genomeSize=220m -nanopore-raw /data1/jbrown/louse_project/temp/minion_basecalling/combo_12345/26x_full_combo_12345.fq
	touch $@

canu_v3_copy: temp/canu/v3_copy/canu_done.txt

temp/canu/v3_extra_run/canu_done.txt: /data1/jbrown/louse_project/temp/minion_basecalling/combo_12345/26x_full_combo_12345.fq
	mkdir -p `dirname $@`
	-rm $@
	canu -p louse_canu_v3 -d temp/canu/v3_extra_run -s scripts/canu/v3/specfile.txt genomeSize=220m -nanopore-raw /data1/jbrown/louse_project/temp/minion_basecalling/combo_12345/26x_full_combo_12345.fq
	touch $@

temp/canu/v3_copy/canu_done.txt: temp/canu/v3/canu_done.txt
	mkdir -p `dirname $@`
	-rm $@
	rsync -avP `dirname $<`/ `dirname $@`/
	touch $@

temp/canu/v3/canu_v3_lengths.txt: scripts/util/read_lengths.py temp/canu/v3/canu_done.txt
	mkdir -p `dirname $@`
	-rm $@
	python $< temp/canu/v3/louse_canu_v3.contigs.fasta > $@
	touch $@
temp/canu/v3/canu_cumcov_plot.pdf: scripts/util/cumcov_plot.R temp/canu/v3/canu_v3_lengths.txt
	mkdir -p `dirname $@`
	-rm $@
	Rscript $^ "Cumulative coverage of Canu assembly v3" $@
	touch $@
plots/canu/v3/canu_cumcov_plot.pdf: temp/canu/v3/canu_cumcov_plot.pdf
	mkdir -p `dirname $@`
	-rm $@
	rsync -avP $< $@
	touch $@

temp/canu/v3/clc_v3_lengths.txt: scripts/util/read_lengths.py raw_data/previous_assemblies/taxon_filtered_louse/ALM_F2Male_MDS349_CLCassembly.fasta
	mkdir -p `dirname $@`
	-rm $@
	python $< raw_data/previous_assemblies/taxon_filtered_louse/ALM_F2Male_MDS349_CLCassembly.fasta > $@
	touch $@
temp/canu/v3/canu_cumcov_multiplot.pdf: scripts/util/cumcov_plot_multiple_v3.R temp/canu/v2/canu_v2_lengths.txt temp/canu/v1/canu_v1_lengths.txt temp/canu/v3/clc_v3_lengths.txt temp/canu/v3/canu_v3_lengths.txt
	mkdir -p `dirname $@`
	-rm $@
	Rscript $^ "Cumulative coverage of various assemblies" $@
	touch $@
plots/canu/v3/canu_cumcov_multiplot.pdf: temp/canu/v3/canu_cumcov_multiplot.pdf
	mkdir -p `dirname $@`
	-rm $@
	rsync -avP $< $@
	touch $@



########################################
#first falcon attempt, using all data from 1st and 2nd cells:

falcon_v1: temp/falcon/v1/falcon_done.txt

temp/falcon/v1/falcon_done.txt: scripts/falcon/v1/fc_run.cfg scripts/falcon/v1/input.fofn
	mkdir -p `dirname $@`
	-rm $@
	rsync -avP `dirname $<`/ `dirname $@`
	#export PATH="/data1/jbrown/local_programs/anaconda/install_dir/anaconda/bin:$$PATH" && home_pwd=`pwd` && source activate py279 && source /data1/jbrown/local_programs/falcon/falcon-integrate/FALCON-integrate/env.sh && cd `dirname $@` && fc_run.py $${home_pwd}/$<
	home_pwd=`pwd` && cd `dirname $@` && fc_run.py $${home_pwd}/$<
	touch $@

########################################
#second falcon attempt, using all data from all 5 cells:

falcon_v2: temp/falcon/v2/falcon_done.txt

temp/falcon/v2/falcon_done.txt: scripts/falcon/v2/fc_run.cfg scripts/falcon/v2/input.fofn
	mkdir -p `dirname $@`
	-rm $@
	rsync -avP `dirname $<`/ `dirname $@`
	export PATH="/data1/jbrown/local_programs/anaconda/install_dir/anaconda/bin:$$PATH" && home_pwd=`pwd` && source activate py279 && source /data1/jbrown/local_programs/falcon/falcon-integrate/FALCON-integrate/env.sh && cd `dirname $@` && fc_run.py $${home_pwd}/$<
	#home_pwd=`pwd` && cd `dirname $@` && fc_run.py $${home_pwd}/$<
	touch $@

########################################
#first quickmerge attempt, on old data:

quickmerge_v1: temp/quickmerge/v1/merged.fasta

temp/quickmerge/v1/merged.fasta: temp/canu/v1/canu_done.txt temp/dbg2olc/v4/dbg2olc/backbone_raw.fasta
	mkdir -p `dirname $@`
	#/data1/jbrown/louse_project/temp/canu/v1/louse_canu_v1.contigs.fasta
	#/data1/jbrown/louse_project/temp/dbg2olc/v4/dbg2olc/backbone_raw.fasta
	-rm $@
	hd=`pwd` && cd `dirname $@` && cp /data1/jbrown/louse_project/temp/canu/v1/louse_canu_v1.contigs.fasta canu.fa && cp /data1/jbrown/louse_project/temp/dbg2olc/v4/dbg2olc/backbone_raw.fasta dbg2olc.fa && merge_wrapper.py -pre merged dbg2olc.fa canu.fa

quickmerge_v1_rev: temp/quickmerge/v1_rev/merged.fasta

temp/quickmerge/v1_rev/merged.fasta: temp/canu/v1/canu_done.txt temp/dbg2olc/v4/dbg2olc/backbone_raw.fasta
	mkdir -p `dirname $@`
	#/data1/jbrown/louse_project/temp/canu/v1/louse_canu_v1.contigs.fasta
	#/data1/jbrown/louse_project/temp/dbg2olc/v4/dbg2olc/backbone_raw.fasta
	-rm $@
	hd=`pwd` && cd `dirname $@` && cp /data1/jbrown/louse_project/temp/canu/v1/louse_canu_v1.contigs.fasta canu.fa && cp /data1/jbrown/louse_project/temp/dbg2olc/v4/dbg2olc/backbone_raw.fasta dbg2olc.fa && merge_wrapper.py -pre merged canu.fa dbg2olc.fa

########################################
#second quickmerge attempt, on final data:

quickmerge_v2_all: temp/quickmerge/v2/merged.fasta temp/quickmerge/v2_raw/merged.fasta temp/quickmerge/v2_final/merged.fasta

quickmerge_v2: temp/quickmerge/v2/merged.fasta

temp/quickmerge/v2/merged.fasta: temp/canu/v2/canu_done.txt
	mkdir -p `dirname $@`
	-rm $@
	hd=`pwd` && cd `dirname $@` && cp /data1/jbrown/louse_project/temp/canu/v2/louse_canu_v2.contigs.fasta canu.fa && cp /data1/jbrown/louse_project/raw_data/from_hpc/v1_to_keep/backbone_corr.fasta dbg2olc.fa && merge_wrapper.py -pre merged canu.fa dbg2olc.fa

quickmerge_v2_raw: temp/quickmerge/v2_raw/merged.fasta

temp/quickmerge/v2_raw/merged.fasta: temp/canu/v2/canu_done.txt
	mkdir -p `dirname $@`
	-rm $@
	hd=`pwd` && cd `dirname $@` && cp /data1/jbrown/louse_project/temp/canu/v2/louse_canu_v2.contigs.fasta canu.fa && cp /data1/jbrown/louse_project/raw_data/from_hpc/v1_to_keep/backbone_raw.fasta dbg2olc.fa && merge_wrapper.py -pre merged canu.fa dbg2olc.fa

quickmerge_v2_final: temp/quickmerge/v2_final/merged.fasta

temp/quickmerge/v2_final/merged.fasta: temp/canu/v2/canu_done.txt
	mkdir -p `dirname $@`
	-rm $@
	hd=`pwd` && cd `dirname $@` && cp /data1/jbrown/louse_project/temp/canu/v2/louse_canu_v2.contigs.fasta canu.fa && cp /data1/jbrown/louse_project/raw_data/from_hpc/v1_to_keep/final_assembly.fasta dbg2olc.fa && merge_wrapper.py -pre merged canu.fa dbg2olc.fa

#/data1/jbrown/louse_project/temp/minion_basecalling/combo_12345/combo_12345_25x.fq

################################################################################
################################################################################

#first pilon attempt, using canu assembly on all minion data and all available Illumina reads:

#/data1/mshapiro/data/columbicola/180bp_library/duplicates_removed/columbicola_180_seqyclean_PE1.fastq.gz
#/data1/mshapiro/data/columbicola/180bp_library/duplicates_removed/columbicola_180_seqyclean_PE2.fastq.gz
#/data1/mshapiro/data/columbicola/500bp_library/columbicola_500_seqyclean_PE1.fastq
#/data1/mshapiro/data/columbicola/500bp_library/columbicola_500_seqyclean_PE2.fastq

#/data1/mshapiro/data/columbicola/180bp_library/duplicates_removed/columbicola_180_seqyclean_PE1.fastq.gz
#/data1/mshapiro/data/columbicola/180bp_library/duplicates_removed/columbicola_180_seqyclean_PE2.fastq.gz
#/data1/mshapiro/data/columbicola/180bp_library/duplicates_removed/columbicola_180_seqyclean_SE.fastq.gz
#/data1/mshapiro/data/columbicola/180bp_library/no_duplicates_removed/columbicola_180_seqyclean_PE1.fastq.gz
#/data1/mshapiro/data/columbicola/180bp_library/no_duplicates_removed/columbicola_180_seqyclean_PE2.fastq.gz
#/data1/mshapiro/data/columbicola/180bp_library/no_duplicates_removed/columbicola_180_seqyclean_SE.fastq.gz
#/data1/mshapiro/data/columbicola/500bp_library/columbicola_500_seqyclean_PE1.fastq
#/data1/mshapiro/data/columbicola/500bp_library/columbicola_500_seqyclean_PE2.fastq
#/data1/mshapiro/data/columbicola/500bp_library/columbicola_500_seqyclean_SE.fastq
#/data1/mshapiro/data/columbicola/3500bp_library/columbicola_3500_seqyclean_PE1.fastq.gz
#/data1/mshapiro/data/columbicola/3500bp_library/columbicola_3500_seqyclean_PE2.fastq.gz
#/data1/mshapiro/data/columbicola/3500bp_library/columbicola_3500_seqyclean_SE.fastq.gz
#/data1/mshapiro/data/columbicola/8200bp_library/columbicola_8200_seqyclean_SE.fastq.gz
#/data1/mshapiro/data/columbicola/8200bp_library/columbicola_8200_seqyclean_PE1.fastq.gz
#/data1/mshapiro/data/columbicola/8200bp_library/columbicola_8200_seqyclean_PE2.fastq.gz

temp/pilon/v1/canu_v2_ref.fa: temp/canu/v2/louse_canu_v2.contigs.fasta
	mkdir -p `dirname $@`
	cp $< $@
	samtools faidx $@
	cp ${@}.fai `dirname $@`/`basename $@ .fa`.fai
	bwa index $@

temp/pilon/v1/fragreads_f.fq: /data1/mshapiro/data/columbicola/180bp_library/duplicates_removed/columbicola_180_seqyclean_PE1.fastq.gz /data1/mshapiro/data/columbicola/500bp_library/columbicola_500_seqyclean_PE1.fastq
	mkdir -p `dirname $@`
	cat $^ | gunzip -c > $@

temp/pilon/v1/fragreads_r.fq: /data1/mshapiro/data/columbicola/180bp_library/duplicates_removed/columbicola_180_seqyclean_PE2.fastq.gz /data1/mshapiro/data/columbicola/500bp_library/columbicola_500_seqyclean_PE2.fastq
	mkdir -p `dirname $@`
	cat $^ | gunzip -c > $@

temp/pilon/v1/jumpreads_f.fq: /data1/mshapiro/data/columbicola/3500bp_library/columbicola_3500_seqyclean_PE1.fastq.gz /data1/mshapiro/data/columbicola/8200bp_library/columbicola_8200_seqyclean_PE1.fastq.gz
	mkdir -p `dirname $@`
	cat $^ | gunzip -c > $@

temp/pilon/v1/jumpreads_r.fq: /data1/mshapiro/data/columbicola/3500bp_library/columbicola_3500_seqyclean_PE2.fastq.gz /data1/mshapiro/data/columbicola/8200bp_library/columbicola_8200_seqyclean_PE2.fastq.gz
	mkdir -p `dirname $@`
	cat $^ | gunzip -c > $@

temp/pilon/v1/frags.unsorted.bam: temp/pilon/v1/canu_v2_ref.fa temp/pilon/v1/fragreads_f.fq temp/pilon/v1/fragreads_r.fq
	mkdir -p `dirname $@`
	-rm $@
	#bwa mem $^ | samtools view -Sbh > $@
	bwa mem $^ | samtools view -Sbh - > $@

temp/pilon/v1/jumps.unsorted.bam: temp/pilon/v1/canu_v2_ref.fa temp/pilon/v1/jumpreads_f.fq temp/pilon/v1/jumpreads_r.fq
	mkdir -p `dirname $@`
	-rm $@
	#bwa mem $^ | samtools view -Sbh > $@
	bwa mem $^ | samtools view -Sbh - > $@

temp/pilon/v1/frags.bam: temp/pilon/v1/frags.unsorted.bam
	mkdir -p `dirname $@`
	-rm $@
	samtools sort -O bam -o $@ -T frags_sort_tempfiles < $<
	samtools index $@

temp/pilon/v1/jumps.bam: temp/pilon/v1/jumps.unsorted.bam
	mkdir -p `dirname $@`
	-rm $@
	samtools sort -O bam -o $@ -T jumps_sort_tempfiles < $<
	samtools index $@

temp/pilon/v1/piloned.fasta: temp/pilon/v1/canu_v2_ref.fa temp/pilon/v1/frags.bam temp/pilon/v1/jumps.bam
	mkdir -p `dirname $@`
	-rm $@
	pilon --genome temp/canu/v2/louse_canu_v2.contigs.fasta --frags temp/pilon/v1/frags.bam --jumps temp/pilon/v1/jumps.bam --output piloned --outdir `dirname $@` --changes --vcf --vcfqe --tracks --fix all

#temp/covcens/clc_outbred/clc_outbred_covcens_done_strict_bed.txt
#temp/covcens/clc_inbred/clc_inbred_covcens_done_strict_bed.txt
#temp/covcens/clc_inbred/clc_inbred_covcens_done_strict_bed.txt: scripts/util/snptable_to_bed.py temp/covcens/clc_inbred/clc_inbred_covcens_done_strict.txt
#	mkdir -p `dirname $@`
#	-rm $@
#	python $< temp/covcens/clc_inbred/clc_inbred_covcens_strict.txt > `dirname $@`/clc_inbred_covcens_strict.bed
#	touch $@
#temp/bwa_gatk/anna_assembly_outbred_pedcons2/data/snp_tables/only-PASS-Q30-SNPs.txt

#temp/covcens/intersect/strict_outbredintersect_to_repmask_done.txt: temp/covcens/intersect/strict_outbredintersect_done.txt temp/repeatmasker/pedcons/pedcons_repeatmasker_done.txt
#	mkdir -p `dirname $@`
#	-rm $@
#	bedtools intersect -a temp/covcens/intersect/strict_outbredintersect.bed -b temp/repeatmasker/pedcons/anna_assembly_to_nr_R1-ex.fasta.out.gff -v > `dirname $@`/strict_outbred_to_repmask.bed
#	touch $@

alltrin: temp/trinity/v1/notrim/trinity_notrim.fasta temp/trinity/v1/trim/trinity_trim.fasta temp/trinity/v1/notrim_jaccard/trinity_notrim_jaccard.fasta temp/trinity/v1/trim_jaccard/trinity_trim_jaccard.fasta

raw_data/rnaseq/1/14722R/Fastq/14722X1_171117_D00294_0357_BCBYP5ANXX_8_1.txt: raw_data/rnaseq/1/14722R/Fastq/14722X1_171117_D00294_0357_BCBYP5ANXX_8_1.txt.gz raw_data/rnaseq/1/14722R/Fastq/14722X1_171117_D00294_0357_BCBYP5ANXX_8_2.txt.gz
	mkdir -p `dirname $@`
	gunzip -c raw_data/rnaseq/1/14722R/Fastq/14722X1_171117_D00294_0357_BCBYP5ANXX_8_1.txt.gz > raw_data/rnaseq/1/14722R/Fastq/14722X1_171117_D00294_0357_BCBYP5ANXX_8_1.txt

raw_data/rnaseq/1/14722R/Fastq/14722X1_171117_D00294_0357_BCBYP5ANXX_8_2.txt: raw_data/rnaseq/1/14722R/Fastq/14722X1_171117_D00294_0357_BCBYP5ANXX_8_1.txt.gz raw_data/rnaseq/1/14722R/Fastq/14722X1_171117_D00294_0357_BCBYP5ANXX_8_2.txt.gz
	mkdir -p `dirname $@`
	gunzip -c raw_data/rnaseq/1/14722R/Fastq/14722X1_171117_D00294_0357_BCBYP5ANXX_8_2.txt.gz > raw_data/rnaseq/1/14722R/Fastq/14722X1_171117_D00294_0357_BCBYP5ANXX_8_2.txt

temp/trinity/v1/notrim/trinity_notrim.fasta: raw_data/rnaseq/1/14722R/Fastq/14722X1_171117_D00294_0357_BCBYP5ANXX_8_1.txt raw_data/rnaseq/1/14722R/Fastq/14722X1_171117_D00294_0357_BCBYP5ANXX_8_2.txt
	mkdir -p `dirname $@`
	myhome=`pwd` && cd `dirname $@` && Trinity --seqType fq --max_memory 100G --left $< --right raw_data/rnaseq/1/14722R/Fastq/14722X1_171117_D00294_0357_BCBYP5ANXX_8_2.txt --CPU 16
	touch $@

#trimmomatic PE -phred33 $^ raw_data/rnaseq/1/14722R/Fastq/14722X1_171117_D00294_0357_BCBYP5ANXX_8_1_trim.txt.gz raw_data/rnaseq/1/14722R/Fastq/14722X1_171117_D00294_0357_BCBYP5ANXX_8_2_trim.txt.gz raw_data/rnaseq/1/14722R/Fastq/14722X1_171117_D00294_0357_BCBYP5ANXX_8_1_trim_unpaired.txt.gz raw_data/rnaseq/1/14722R/Fastq/14722X1_171117_D00294_0357_BCBYP5ANXX_8_2_trim_unpaired.txt.gz ILLUMINACLIP:TruSeq3-PE.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36
raw_data/rnaseq/1/14722R/Fastq/14722X1_171117_D00294_0357_BCBYP5ANXX_8_1_trim.txt.gz: raw_data/rnaseq/1/14722R/Fastq/14722X1_171117_D00294_0357_BCBYP5ANXX_8_1.txt.gz raw_data/rnaseq/1/14722R/Fastq/14722X1_171117_D00294_0357_BCBYP5ANXX_8_2.txt.gz
	mkdir -p `dirname $@`
	trimmomatic PE -phred33 $^ raw_data/rnaseq/1/14722R/Fastq/14722X1_171117_D00294_0357_BCBYP5ANXX_8_1_trim.txt.gz raw_data/rnaseq/1/14722R/Fastq/14722X1_171117_D00294_0357_BCBYP5ANXX_8_2_trim.txt.gz raw_data/rnaseq/1/14722R/Fastq/14722X1_171117_D00294_0357_BCBYP5ANXX_8_1_trim_unpaired.txt.gz raw_data/rnaseq/1/14722R/Fastq/14722X1_171117_D00294_0357_BCBYP5ANXX_8_2_trim_unpaired.txt.gz ILLUMINACLIP:raw_data/trimmomatic_adapters/adapters/NexteraPE-PE.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36

raw_data/rnaseq/1/14722R/Fastq/14722X1_171117_D00294_0357_BCBYP5ANXX_8_1_trim.txt: raw_data/rnaseq/1/14722R/Fastq/14722X1_171117_D00294_0357_BCBYP5ANXX_8_1_trim.txt.gz
	gunzip -c $< > $@

raw_data/rnaseq/1/14722R/Fastq/14722X1_171117_D00294_0357_BCBYP5ANXX_8_1_trim_unpaired.txt: raw_data/rnaseq/1/14722R/Fastq/14722X1_171117_D00294_0357_BCBYP5ANXX_8_1_trim_unpaired.txt.gz
	gunzip -c $< > $@

temp/trinity/v1/trim/trinity_trim.fasta: raw_data/rnaseq/1/14722R/Fastq/14722X1_171117_D00294_0357_BCBYP5ANXX_8_1_trim.txt raw_data/rnaseq/1/14722R/Fastq/14722X1_171117_D00294_0357_BCBYP5ANXX_8_1_trim_unpaired.txt
	mkdir -p `dirname $@`
	myhome=`pwd` && cd `dirname $@` && Trinity --seqType fq --max_memory 100G --left $${myhome}/$< --right $${myhome}/raw_data/rnaseq/1/14722R/Fastq/14722X1_171117_D00294_0357_BCBYP5ANXX_8_1_trim_unpaired.txt --CPU 16
	touch $@

temp/trinity/v1/trim_jaccard/trinity_trim_jaccard.fasta: raw_data/rnaseq/1/14722R/Fastq/14722X1_171117_D00294_0357_BCBYP5ANXX_8_1_trim.txt raw_data/rnaseq/1/14722R/Fastq/14722X1_171117_D00294_0357_BCBYP5ANXX_8_1_trim_unpaired.txt
	mkdir -p `dirname $@`
	myhome=`pwd` && cd `dirname $@` && Trinity --jaccard_clip --seqType fq --max_memory 100G --left $${myhome}/$< --right $${myhome}/raw_data/rnaseq/1/14722R/Fastq/14722X1_171117_D00294_0357_BCBYP5ANXX_8_1_trim_unpaired.txt --CPU 16
	touch $@

#--jaccard_clip
temp/trinity/v1/notrim_jaccard/trinity_notrim_jaccard.fasta: raw_data/rnaseq/1/14722R/Fastq/14722X1_171117_D00294_0357_BCBYP5ANXX_8_1.txt raw_data/rnaseq/1/14722R/Fastq/14722X1_171117_D00294_0357_BCBYP5ANXX_8_2.txt
	mkdir -p `dirname $@`
	myhome=`pwd` && cd `dirname $@` && Trinity --jaccard_clip --seqType fq --max_memory 100G --left $${myhome}/$< --right $${myhome}/raw_data/rnaseq/1/14722R/Fastq/14722X1_171117_D00294_0357_BCBYP5ANXX_8_2.txt --CPU 16
	touch $@

################################################################################
################################################################################
# assemble MinION RNAseq reads:
#
#
########################################
#assemble MinION RNAseq reads with Canu:

canu_rnaseq_v1: temp/canu_rnaseq/v1_copy/canu_rnaseq_copy_done.txt plots/canu_rnaseq/v1/canu_rnaseq_cumcov_plot.pdf 

temp/canu_rnaseq/v1/canu_rnaseq_done.txt: /data1/jbrown/louse_project/temp/minion_rna_basecalling/1-4/minion_rna1-4_1d_combo.fq
	mkdir -p `dirname $@`
	-rm $@
	canu -correct -p louse_canu_rnaseq_v1 -d temp/canu_rnaseq/v1 -s scripts/canu_rnaseq/v1/specfile3.txt genomeSize=88m stopOnReadQuality=false -nanopore-raw /data1/jbrown/louse_project/temp/minion_rna_basecalling/1-4/minion_rna1-4_1d_combo.fq
	touch $@

temp/canu_rnaseq/v1_copy/canu_rnaseq_copy_done.txt: temp/canu_rnaseq/v1/canu_rnaseq_done.txt
	mkdir -p `dirname $@`
	-rm $@
	rsync -avP `dirname $<`/ `dirname $@`/
	touch $@

temp/canu_rnaseq/v1_copy/canu_rnaseq_done.txt: temp/canu_rnaseq/v1/canu_rnaseq_done.txt
	mkdir -p `dirname $@`
	-rm $@
	rsync -avP `dirname $<`/ `dirname $@`/
	touch $@

temp/canu_rnaseq/v1/canu_rnaseq_v1_lengths.txt: scripts/util/read_lengths.py temp/canu_rnaseq/v1/canu_rnaseq_done.txt
	mkdir -p `dirname $@`
	-rm $@
	python $< temp/canu_rnaseq/v1/louse_canu_rnaseq_v1.contigs.fasta > $@
	touch $@
temp/canu_rnaseq/v1/canu_rnaseq_cumcov_plot.pdf: scripts/util/cumcov_plot.R temp/canu_rnaseq/v1/canu_rnaseq_v1_lengths.txt
	mkdir -p `dirname $@`
	-rm $@
	Rscript $^ "Cumulative coverage of Canu assembly v1" $@
	touch $@
plots/canu_rnaseq/v1/canu_rnaseq_cumcov_plot.pdf: temp/canu_rnaseq/v1/canu_rnaseq_cumcov_plot.pdf
	mkdir -p `dirname $@`
	-rm $@
	rsync -avP $< $@
	touch $@

canu_rnaseq_v1extra: temp/canu_rnaseq/v1extra_copy/canu_rnaseq_copy_done.txt plots/canu_rnaseq/v1extra/canu_rnaseq_cumcov_plot.pdf 

temp/canu_rnaseq/v1extra/canu_rnaseq_done.txt: /data1/jbrown/louse_project/temp/minion_rna_basecalling/1-4/minion_rna1-4_1d_combo.fq
	mkdir -p `dirname $@`
	-rm $@
	canu -correct -p louse_canu_rnaseq_v1extra -d temp/canu_rnaseq/v1extra -s scripts/canu_rnaseq/v1extra/specfile3.txt genomeSize=88m stopOnReadQuality=false -nanopore-raw /data1/jbrown/louse_project/temp/minion_rna_basecalling/1-4/minion_rna1-4_1d_combo.fq
	touch $@

temp/canu_rnaseq/v1extra_copy/canu_rnaseq_copy_done.txt: temp/canu_rnaseq/v1extra/canu_rnaseq_done.txt
	mkdir -p `dirname $@`
	-rm $@
	rsync -avP `dirname $<`/ `dirname $@`/
	touch $@

temp/canu_rnaseq/v1extra_copy/canu_rnaseq_done.txt: temp/canu_rnaseq/v1extra/canu_rnaseq_done.txt
	mkdir -p `dirname $@`
	-rm $@
	rsync -avP `dirname $<`/ `dirname $@`/
	touch $@

temp/canu_rnaseq/v1extra/canu_rnaseq_v1extra_lengths.txt: scripts/util/read_lengths.py temp/canu_rnaseq/v1extra/canu_rnaseq_done.txt
	mkdir -p `dirname $@`
	-rm $@
	python $< temp/canu_rnaseq/v1extra/louse_canu_rnaseq_v1extra.contigs.fasta > $@
	touch $@
temp/canu_rnaseq/v1extra/canu_rnaseq_cumcov_plot.pdf: scripts/util/cumcov_plot.R temp/canu_rnaseq/v1extra/canu_rnaseq_v1extra_lengths.txt
	mkdir -p `dirname $@`
	-rm $@
	Rscript $^ "Cumulative coverage of Canu assembly v1extra" $@
	touch $@
plots/canu_rnaseq/v1extra/canu_rnaseq_cumcov_plot.pdf: temp/canu_rnaseq/v1extra/canu_rnaseq_cumcov_plot.pdf
	mkdir -p `dirname $@`
	-rm $@
	rsync -avP $< $@
	touch $@

########################################
# assemble MinION RNAseq reads with Trinity:

alltrin_minion: temp/trinity_minion/v1/notrim/trinity_minion.fasta 

/data1/jbrown/louse_project/temp/minion_rna_basecalling/1-4/minion_rna1-4_1d_combo_trinity_headers.fq: /data1/jbrown/louse_project/temp/minion_rna_basecalling/1-4/minion_rna1-4_1d_combo.fq
	mkdir -p `dirname $@`
	cat $< | awk '{if (NR $(PERCENT)4 == 1){printf("@minionreads[_$(PERCENT)d]/1\n", NR)} else {print $$0}}' > $@

temp/trinity_minion/v1/notrim/trinity_minion.fasta: /data1/jbrown/louse_project/temp/minion_rna_basecalling/1-4/minion_rna1-4_1d_combo_trinity_headers.fq
	mkdir -p `dirname $@`
	myhome=`pwd` && cd `dirname $@` && Trinity --seqType fq --max_memory 100G --single $< --CPU 16
	touch $@

################################################################################
################################################################################
# Population sequencing

pop001_fastqc: temp/population_sequencing/fastqc/pop001_fastqc_done.txt

temp/population_sequencing/fastqc/pop001_fastqc_done.txt: scripts/population_sequencing/fastqc/fastqc_all.sh scripts/population_sequencing/fastqc/all_fastq.txt
	mkdir -p `dirname $@`
	bash $<
	touch $@

temp/population_sequencing/bwa/bwa_all/1/bwa_done.txt: scripts/population_sequencing/bwa/bwa_all/population_bwa_all.sh temp/pilon/v1/piloned.fasta
	mkdir -p `dirname $@`
	bash $<
	touch $@

temp/population_sequencing/bwa/bwa_all/1_mito/bwa_done.txt: scripts/population_sequencing/bwa/bwa_all/population_bwa_all_mito.sh raw_data/mito_ref/Cocol_mt_contigsUnpaired.fasta
	mkdir -p `dirname $@`
	bash $<
	touch $@

temp/population_sequencing/full_gatk/1/inlist.txt:
	mkdir -p `dirname $@`
	find `pwd`/raw_data/population_sequencing/1/15515R/Fastq -name '*gz' -type f | sort | paste - - > $@

temp/population_sequencing/full_gatk/1/full_gatk_done.txt: scripts/population_sequencing/full_gatk/1/make_makefile.py temp/population_sequencing/full_gatk/1/inlist.txt
	mkdir -p `dirname $@`
	rsync -avP `dirname $<`/ `dirname $@`
	myhome=`pwd` ; cd `dirname $@` ; \
		python `basename $<` inlist.txt $${myhome}/temp/pilon/v1/piloned.fasta ./ 32 32 128 > ./Makefile 
	make -C `dirname $@` -j 32
	touch $@

temp/population_sequencing/full_gatk/1_test/full_gatk_test_done.txt: scripts/population_sequencing/full_gatk/1/make_makefile.py temp/population_sequencing/full_gatk/1_test/inlist_test.txt
	mkdir -p `dirname $@`
	rsync -avP `dirname $<`/ `dirname $@`
	myhome=`pwd` ; cd `dirname $@` ; \
		python `basename $<` inlist_test.txt $${myhome}/temp/pilon/v1/piloned.fasta ./ 32 32 128 > ./Makefile 
	make -C `dirname $@` -j 32
	touch $@

pop002_fastqc: temp/population_sequencing/2/fastqc/pop002_fastqc_done.txt

temp/population_sequencing/2/fastqc/pop002_fastqc_done.txt: scripts/population_sequencing/2/fastqc/fastqc_all.sh scripts/population_sequencing/2/fastqc/all_fastq.txt
	mkdir -p `dirname $@`
	bash $<
	touch $@

#/data1/jbrown/louse_project/scripts/population_sequencing/fastqc/fastqc_all.sh
#/data1/jbrown/louse_project/scripts/population_sequencing/fastqc/all_fastq.txt

################################################################################
################################################################################
# minimap minion rnaseq data:

temp/minion_rnaseq_minimap2/1/ovlpfull.paf: temp/minion_rna_basecalling/1-4/minion_rna1-4_1d_combo.fq
	mkdir -p `dirname $@`
	home=`pwd` && \
		cd `dirname $@` && \
		rsync -avP $${home}/${<} ./ && \
		minimap2 -x ava-ont minion_rna1-4_1d_combo.fq minion_rna1-4_1d_combo.fq > ovlpfull.paf

temp/minion_rnaseq_carnac/1/minion_rna1-4_1d_combo.fa: temp/minion_rna_basecalling/1-4/minion_rna1-4_1d_combo.fq
	mkdir -p `dirname $@`
	fq2fa $< > $@

temp/minion_rnaseq_carnac/1/input_CARNAC.txt: temp/minion_rnaseq_minimap2/1/ovlpfull.paf temp/minion_rnaseq_carnac/1/minion_rna1-4_1d_combo.fa
	mkdir -p `dirname $@`
	paf_to_CARNAC.py $< temp/minion_rnaseq_carnac/1/minion_rna1-4_1d_combo.fa $@

temp/minion_rnaseq_carnac/1/output_CARNAC.txt: temp/minion_rnaseq_carnac/1/input_CARNAC.txt 
	mkdir -p `dirname $@`
	ulimit -s unlimited && CARNAC-LR -f $< -o $@
		
temp/minion_rnaseq_carnac/1/output_CARNAC.fa.gz: scripts/carnac/carnac2fa.py temp/minion_rnaseq_carnac/1/output_CARNAC.txt temp/minion_rnaseq_carnac/1/minion_rna1-4_1d_combo.fa
	mkdir -p `dirname $@`/outs
	python $^ | pigz -p 32 -c > $@
	touch $@

################################################################################
################################################################################
#raw_data/hic_scaffold/pigeon_lice_ctgs_breaks_final.review.fasta
# plotting
#

temp/hic_scaffold/hic_scaf_lengths.txt: scripts/util/read_lengths.py raw_data/hic_scaffold/pigeon_lice_ctgs_breaks_final.review.fasta
	mkdir -p `dirname $@`
	-rm $@
	python $< raw_data/hic_scaffold/pigeon_lice_ctgs_breaks_final.review.fasta > $@
	touch $@
temp/hic_scaffold/hic_scaf_cumplot.pdf: scripts/util/cumcov_plot.R temp/hic_scaffold/hic_scaf_lengths.txt
	mkdir -p `dirname $@`
	-rm $@
	Rscript $^ "Cumulative coverage of Hi-C scaffolded assembly" $@
	touch $@
plots/hic_scaffold/hic_scaf_cumplot.pdf: temp/hic_scaffold/hic_scaf_cumplot.pdf
	mkdir -p `dirname $@`
	-rm $@
	rsync -avP $< $@
	touch $@

temp/hic_scaffold/hic_scaf_multiplot.pdf: scripts/util/cumcov_plot_multiple_v3.R temp/hic_scaffold/hic_scaf_lengths.txt temp/canu/v2/canu_v2_lengths.txt temp/canu/v1/canu_v1_lengths.txt temp/canu/v3/clc_v3_lengths.txt temp/canu/v3/canu_v3_lengths.txt
	mkdir -p `dirname $@`
	-rm $@
	Rscript $^ "Cumulative coverage of various assemblies" $@
	touch $@
plots/hic_scaffold/hic_scaf_multiplot.pdf: temp/hic_scaffold/hic_scaf_multiplot.pdf
	mkdir -p `dirname $@`
	-rm $@
	rsync -avP $< $@
	touch $@

################################################################################
################################################################################

mrna_align_final: temp/minion_rna_alignment/1-4_final_genome/mrna_align_md.sam temp/minion_rna_alignment/1-4_final_genome/mrna_align_sorted.bam temp/minion_rna_alignment/1-4_final_genome/mrna_align.bam temp/minion_rna_alignment/1-4_final_genome/mrna_align.sam

temp/minion_rna_alignment/1-4_final_genome/mrna_align.sam: temp/minion_rna_basecalling/1-4/minion_rna1-4_1d_combo.fq raw_data/hic_scaffold/pigeon_lice_ctgs_breaks_final.review.fasta
	mkdir -p `dirname $@`
	graphmap align -t 16 -r raw_data/hic_scaffold/pigeon_lice_ctgs_breaks_final.review.fasta -d $< -o $@
temp/minion_rna_alignment/1-4_final_genome/mrna_align.bam: temp/minion_rna_alignment/1-4_final_genome/mrna_align.sam
	mkdir -p `dirname $@`
	samtools view -S -b $< > $@
#temp/minion_rna_alignment/1-4_final_genome/mrna_align_sorted.bam: temp/minion_rna_alignment/1-4_final_genome/mrna_align.bam
#	mkdir -p `dirname $@`
#	samtools sort $< temp/minion_rna_alignment/1-4_final_genome/mrna_align_sorted
#temp/minion_rna_alignment/1-4_final_genome/mrna_align_md.sam: temp/minion_rna_alignment/1-4_final_genome/mrna_align.sam temp/canu/v1/canu_done.txt
#	mkdir -p `dirname $@`
#	samtools fillmd -S $< raw_data/hic_scaffold/pigeon_lice_ctgs_breaks_final.review.fasta > $@ 2>temp.txt

temp/split_minion_rna_for_carnac/done.txt: temp/minion_rna_alignment/1-4_final_genome/mrna_align.bam
	mkdir -p `dirname $@`/bams
	rsync -avP $< `dirname $@`/bams
	cd `dirname $@`/bams && \
		bamtools split -in mrna_align.bam -reference
	touch $@

temp/split_minion_rna_for_carnac/bam2fa_done.txt: temp/split_minion_rna_for_carnac/done.txt
	mkdir -p `dirname $@`/bam2fq
	mkdir -p `dirname $@`/bam2fa
	cd `dirname $@`/bam2fq && \
		ls ../bams/*REF* | while read i; do \
			bedtools bamtofastq -i $$i -fq `basename $$i .bam`.fq ; \
			fq2fa `basename $$i .bam`.fq > ../bam2fa/`basename $$i .bam`.fa ; \
		done
	touch $@

temp/split_minion_rna_for_carnac/minimap_done.txt: temp/split_minion_rna_for_carnac/bam2fa_done.txt
	mkdir -p `dirname $@`/minimap
	home=`pwd` && \
		cd `dirname $@`/minimap && \
		rsync -avP $${home}/`dirname $<`/bam2fa/* ./ && \
		ls *fa | while read i; do \
			echo "minimap2 -x ava-ont $$i $$i > $${home}/"`dirname $@`"/minimap/"`basename $$i .fa`".paf" ; \
		done | parallel -j 32 '{}'
	touch $@

temp/split_minion_rna_for_carnac/incarnac_done.txt: temp/split_minion_rna_for_carnac/minimap_done.txt temp/split_minion_rna_for_carnac/bam2fa_done.txt
	mkdir -p `dirname $@`/carnac
	cd `dirname $@` && \
		find ./minimap -name '*paf' | while read i ; do \
			echo "paf_to_CARNAC.py $$i ./bam2fa/"`basename $$i .paf`".fa carnac/"`basename $$i .paf`"_carnac_in.txt" ; \
		done | parallel -j 32 '{}'
	touch $@

temp/split_minion_rna_for_carnac/outcarnac_done.txt: temp/split_minion_rna_for_carnac/incarnac_done.txt 
	mkdir -p `dirname $@`/carnac
	cd `dirname $@`/carnac && \
		find . -name '*carnac_in.txt' | while read i; do \
			echo "ulimit -s unlimited && CARNAC-LR -f $$i -o "`basename $$i in.txt`"out.txt" ; \
		done | parallel -j 32 '{}'
	touch $@
       	
temp/split_minion_rna_for_carnac/outcarnac_fa_done.txt: scripts/carnac/carnac2fa.py temp/split_minion_rna_for_carnac/outcarnac_done.txt
	mkdir -p `dirname $@`/carnac
	MYHOME=`pwd` && \
	cd `dirname $@`/carnac && \
	find . -name '*carnac_out.txt' | while read i ; do \
		python $${MYHOME}/$< $$i ../bam2fa/`basename $${i} _carnac_out.txt`.fa | pigz -p 32 -c > `basename $$i .txt`_clustered.fa.gz ; \
	done
	touch $@

temp/split_minion_rna_for_carnac/outcarnac_choose_cwt_done.txt: scripts/carnac/choose_cwt_full_500_200.sh scripts/carnac/choose_cwt_full.py temp/split_minion_rna_for_carnac/outcarnac_fa_done.txt
	bash $<

temp/split_minion_rna_for_carnac/chosen_combined/all_filt_w500_m200.fa.gz: scripts/carnac/combine_cwt_full_500_200.sh scripts/carnac/combine_fa.py temp/split_minion_rna_for_carnac/outcarnac_choose_cwt_done.txt
	bash $<

temp/split_minion_rna_for_carnac/outcarnac_choose_cwt_multi_done.txt: scripts/carnac/choose_cwt_full_multi.sh scripts/carnac/choose_cwt_full.py temp/split_minion_rna_for_carnac/outcarnac_fa_done.txt
	bash $<
	touch $@
temp/split_minion_rna_for_carnac/chosen_combined_multi/all_filt_multi_done.txt: scripts/carnac/combine_cwt_full_fa_multi.sh scripts/carnac/combine_fa.py temp/split_minion_rna_for_carnac/outcarnac_choose_cwt_multi_done.txt
	bash $<
	touch $@
temp/split_minion_rna_for_carnac/chosen_combined_mapped/all_filt_mapped_multi_done.txt: scripts/carnac/gmap_all.sh temp/split_minion_rna_for_carnac/chosen_combined_multi/all_filt_multi_done.txt
	bash $<
	touch $@

temp/split_minion_rna_for_carnac/chosen_combined_mapped/gmapped_all.txt: scripts/carnac/gmap_all.sh temp/split_minion_rna_for_carnac/chosen_combined_multi/all_filt_multi_done.txt
	bash $<
	touch $@

#find .. -name '*carnac_out.txt' | xargs dusort | tac | tail -n +2 | head -n 3 | cut -d '        ' -f 2 | while read i ; do \
#        python ../../../scripts/carnac/carnac2fa.py $i ../bam2fa/`basename ${i} _carnac_out.txt`.fa | pigz -p 32 -c > `basename $i .txt`_clustered.fa.gz ; \
#done

genome_alignment_check: temp/minion_genome_alignment/all_1/nanopore_all_genome_aligned.bam.done 

temp/minion_genome_alignment/all_1/nanopore_all_genome_aligned.bam.done: graphmap_all_genome.sh temp/minion_basecalling/combo_12345/minion12345_full_combo.fq.gz /data1/jbrown/louse_project/test_cout/pigeon_lice_ctgs_breaks_final.review.fasta
	mkdir -p `dirname "$@"`
	bash $<
	touch $@

temp/ill_genome_alignment/ill_aligned.bam.done: align_ill_to_genome.sh raw_data/hic_scaffold/pigeon_lice_ctgs_breaks_final.review.fasta /data1/jbrown/louse_project/temp/clean_data/180bp/trimmomatic/180_trimmed_R1_paired.fq.gz /data1/jbrown/louse_project/temp/clean_data/180bp/trimmomatic/180_trimmed_R2_paired.fq.gz
	mkdir -p `dirname "$@"`
	bash $<
	touch $@
