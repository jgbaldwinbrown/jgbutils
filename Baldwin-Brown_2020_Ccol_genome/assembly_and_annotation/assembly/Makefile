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

################################################################################
################################################################################

#first pilon attempt, using canu assembly on all minion data and all available Illumina reads:

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

alltrin: temp/trinity/v1/notrim_jaccard/trinity_notrim_jaccard.fasta

raw_data/rnaseq/1/14722R/Fastq/14722X1_171117_D00294_0357_BCBYP5ANXX_8_1.txt: raw_data/rnaseq/1/14722R/Fastq/14722X1_171117_D00294_0357_BCBYP5ANXX_8_1.txt.gz raw_data/rnaseq/1/14722R/Fastq/14722X1_171117_D00294_0357_BCBYP5ANXX_8_2.txt.gz
	mkdir -p `dirname $@`
	gunzip -c raw_data/rnaseq/1/14722R/Fastq/14722X1_171117_D00294_0357_BCBYP5ANXX_8_1.txt.gz > raw_data/rnaseq/1/14722R/Fastq/14722X1_171117_D00294_0357_BCBYP5ANXX_8_1.txt

raw_data/rnaseq/1/14722R/Fastq/14722X1_171117_D00294_0357_BCBYP5ANXX_8_2.txt: raw_data/rnaseq/1/14722R/Fastq/14722X1_171117_D00294_0357_BCBYP5ANXX_8_1.txt.gz raw_data/rnaseq/1/14722R/Fastq/14722X1_171117_D00294_0357_BCBYP5ANXX_8_2.txt.gz
	mkdir -p `dirname $@`
	gunzip -c raw_data/rnaseq/1/14722R/Fastq/14722X1_171117_D00294_0357_BCBYP5ANXX_8_2.txt.gz > raw_data/rnaseq/1/14722R/Fastq/14722X1_171117_D00294_0357_BCBYP5ANXX_8_2.txt

#--jaccard_clip
temp/trinity/v1/notrim_jaccard/trinity_notrim_jaccard.fasta: raw_data/rnaseq/1/14722R/Fastq/14722X1_171117_D00294_0357_BCBYP5ANXX_8_1.txt raw_data/rnaseq/1/14722R/Fastq/14722X1_171117_D00294_0357_BCBYP5ANXX_8_2.txt
	mkdir -p `dirname $@`
	myhome=`pwd` && cd `dirname $@` && Trinity --jaccard_clip --seqType fq --max_memory 100G --left $${myhome}/$< --right $${myhome}/raw_data/rnaseq/1/14722R/Fastq/14722X1_171117_D00294_0357_BCBYP5ANXX_8_2.txt --CPU 16
	touch $@

################################################################################
################################################################################
# assemble MinION RNAseq reads:

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

genome_alignment_check: temp/minion_genome_alignment/all_1/nanopore_all_genome_aligned.bam.done 

temp/minion_genome_alignment/all_1/nanopore_all_genome_aligned.bam.done: graphmap_all_genome.sh temp/minion_basecalling/combo_12345/minion12345_full_combo.fq.gz /data1/jbrown/louse_project/test_cout/pigeon_lice_ctgs_breaks_final.review.fasta
	mkdir -p `dirname "$@"`
	bash $<
	touch $@

temp/ill_genome_alignment/ill_aligned.bam.done: align_ill_to_genome.sh raw_data/hic_scaffold/pigeon_lice_ctgs_breaks_final.review.fasta /data1/jbrown/louse_project/temp/clean_data/180bp/trimmomatic/180_trimmed_R1_paired.fq.gz /data1/jbrown/louse_project/temp/clean_data/180bp/trimmomatic/180_trimmed_R2_paired.fq.gz
	mkdir -p `dirname "$@"`
	bash $<
	touch $@
