#!/bin/bash
#$ -N dbg2olc_analysis_hum_54x
#$ -pe openmp 8
#$ -R Y
#$ -q bio,pub64
#$ -hold_jid dbg2olc_consensus_hum_54x

# Go to the directory from which the job was launched.
cd $SGE_O_WORKDIR

#/dfs1/bio/jbaldwi1/programs/dbg2olc/Programs

#module load blasr/20140724
module load smrtanalysis/2.2.0
module load MUMmer/3.23

cp ../consensus/consensus_dir/final_assembly.fasta .

nucmer -mumref -l 100 -c 1000 -d 10 REFPATH final_assembly.fasta
dnadiff -d out.delta
show-coords -lcHr out.delta >out.coords
sort -nrk8 out.coords |awk '{n+=$8;print $8 " "n}' |less >out_sorted.txt

perl find_n50_2.pl final_assembly.fasta > n50.txt

#cat plat_assembly_contig.fa 30cell_arabidopsis_pb.fa > ctg_pb.fasta
#sh ./split_and_run_pbdagcon.sh backbone_raw.fasta  DBG2OLC_Consensus_info.txt ctg_pb.fasta ./consensus_dir >consensus_log.txt &


#./DBG2OLC_Linux k 17 KmerCovTh 2 MinOverlap 20 AdaptiveTh 0.002 LD1 0 MinLen 200 Contigs plat_assembly_contig.fa RemoveChimera 1 f 30cell_arabidopsis_pb.fa 
