#!/bin/bash
#$ -N dbg2olc_consensus_hum_54x
#$ -pe openmp 32-64
#$ -R Y
#$ -q bio,som
#$ -hold_jid dbg2olc_hum_54x

# Go to the directory from which the job was launched.
cd $SGE_O_WORKDIR

#/dfs1/bio/jbaldwi1/programs/dbg2olc/Programs

#module load blasr/20140724
module load smrtanalysis/2.2.0

cat /bio/jbaldwi1/dbg2olc_from_dfs2/human/plat_assembly_contig.fa /bio/jbaldwi1/dbg2olc_from_dfs2/human/dbg2olc_54x/data2/downsample_30x/human_filtered_30x_longest.fastq > ctg_pb.fasta

sed -i "s|MYCORES|${CORES}|g" split_and_run_pbdagcon.sh

sh ./split_and_run_pbdagcon.sh ../dbg2olc/backbone_raw.fasta  ../dbg2olc/DBG2OLC_Consensus_info.txt ctg_pb.fasta ./consensus_dir >consensus_log.txt 


#./DBG2OLC_Linux k 17 KmerCovTh 2 MinOverlap 20 AdaptiveTh 0.002 LD1 0 MinLen 200 Contigs plat_assembly_contig.fa RemoveChimera 1 f 30cell_arabidopsis_pb.fa 
