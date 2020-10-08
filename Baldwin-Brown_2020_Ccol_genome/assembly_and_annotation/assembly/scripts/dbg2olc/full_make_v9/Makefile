SHELL := /bin/bash

all: full_dbg2olc

.PHONY: full_dbg2olc init_dbg2olc consensus_dbg2olc analysis_dbg2olc 

.DELETE_ON_ERROR:

#run dbg2olc assembly using only one minion run's data:
full_dbg2olc: dbg2olc/dbg2olc_done.txt consensus/consensus_done.txt analysis/analysis_done.txt all_done.txt

all_done.txt: dbg2olc/dbg2olc_done.txt consensus/consensus_done.txt analysis/analysis_done.txt

init_dbg2olc: dbg2olc/dbg2olc_done.txt

dbg2olc/dbg2olc_done.txt: /data1/jbrown/louse_project/temp/cleaned_clc_assembly/clc_cleaned_assembly_80line.fa /data1/jbrown/louse_project/temp/minion_basecalling/combo_12345/minion12345_full_combo.fa
	mkdir -p dbg2olc consensus consensus_dir analysis/gage analysis/quast analysis/busco analysis/fastats analysis/nucmer
	cd dbg2olc && DBG2OLC_debug k 17 KmerCovTh 2 MinOverlap 20 AdaptiveTh 0.002 LD1 0 MinLen 200 Contigs /data1/jbrown/louse_project/temp/cleaned_clc_assembly/clc_cleaned_assembly.fa RemoveChimera 1 f /data1/jbrown/louse_project/temp/minion_basecalling/combo_12345/minion12345_full_combo.fa
	touch $@

consensus_dbg2olc: consensus/consensus_done.txt

consensus/consensus_done.txt: dbg2olc/dbg2olc_done.txt
	cat /data1/jbrown/louse_project/temp/cleaned_clc_assembly/clc_cleaned_assembly.fa /data1/jbrown/louse_project/temp/minion_basecalling/combo_12345/minion12345_full_combo.fa > consensus/ctg_pb.fasta
	ulimit -n unlimited && cd consensus && sh ./split_and_run_sparc.sh ../dbg2olc/backbone_raw.fasta  ../dbg2olc/DBG2OLC_Consensus_info.txt ctg_pb.fasta ./consensus_dir > consensus/consensus_log.txt
	touch $@

analysis_dbg2olc: analysis/analysis_done.txt
analysis/analysis_done.txt: analysis/gage/gage_done.txt analysis/quast/quast_done.txt analysis/busco/busco_done.txt analysis/fastats/fastats.txt analysis/nucmer/nucmer_done.txt

analysis/final_assembly.fa: consensus/consensus_done.txt
	cp consensus/consensus_dir/final_assembly.fasta analysis/final_assembly.fa

analysis/busco/busco_done.txt: analysis/final_assembly.fa consensus/consensus_done.txt
	cd analysis/busco && run_BUSCO.py -i ../../$< -o BUSCO -l diptera_odb9 -m geno -c 16 -z -r
	touch $@

analysis/quast/quast_done.txt: analysis/final_assembly.fa consensus/consensus_done.txt
	cd analysis/quast && python quast.py ../../$< --debug -t 16 1> analysis/quast/quast_out.txt 2> analysis/quast/quast_err.txt
	touch $@

analysis/fastats/fastats.txt: analysis/final_assembly.fa consensus/consensus_done.txt
	fastatsqual $< > $@

analysis/gage/gage_done.txt: analysis/final_assembly.fa consensus/consensus_done.txt
	cd analysis/gage && getCorrectnessStats.sh gage_fake_reference.fa ../../$< ../../$< > gage_out.txt
	touch $@

analysis/nucmer/nucmer_done.txt: analysis/final_assembly.fa consensus/consensus_done.txt
	cd analysis/nucmer && nucmer -mumref -l 100 -c 1000 -d 10 REFPATH final_assembly.fasta
	cd analysis/nucmer && dnadiff -d out.delta
	cd analysis/nucmer && show-coords -lcHr out.delta >out.coords
	cd analysis/nucmer && sort -nrk8 out.coords |awk '{n+=$8;print $8 " "n}' |less >out_sorted.txt
	touch $@

#diptera_odb9
#
#cp ../consensus/consensus_dir/final_assembly.fasta .
#
#nucmer -mumref -l 100 -c 1000 -d 10 REFPATH final_assembly.fasta
#dnadiff -d out.delta
#show-coords -lcHr out.delta >out.coords
#sort -nrk8 out.coords |awk '{n+=$8;print $8 " "n}' |less >out_sorted.txt
#
#perl find_n50_2.pl final_assembly.fasta > n50.txt

#getCorrectnessStats.sh /dfs1/bio/jbaldwi1/dbg2olc/mel/reference/dmel-all-chromosome-r6.01.fasta pilon.fasta pilon.fasta 1> gage_out.txt 2> gage_err.txt
#rsync -avP ../final_assembly.fasta .

#getCorrectnessStats.sh /bio/jbaldwi1/dbg2olc_from_dfs2/human/dbg2olc_54x/ref/GRCh38.p7/GCA_000001405.22_GRCh38.p7_genomic.fna final_assembly.fasta final_assembly.fasta 1> gage_out.txt 2> gage_err.txt
