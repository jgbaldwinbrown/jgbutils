#!/bin/bash
#$ -N dbg2olc_consensus_pero_abyss
#$ -pe openmp 32-64
#$ -R Y
#$ -q bio,abio,pub64,free64
#$ -hold_jid dbg2olc_pero_abyss
#$ -ckpt blcr

# Go to the directory from which the job was launched.
cd $SGE_O_WORKDIR

#/dfs1/bio/jbaldwi1/programs/dbg2olc/Programs

#module load blasr/20140724
module load smrtanalysis/2.2.0

cat /dfs2/temp/bio/jbaldwi1/peromyscus_data/work/dbg2olc/from_soap/v1_9-18-15/ill_assembly/pero_assembly_soap.scafSeq /dfs2/temp/bio/jbaldwi1/peromyscus_data/data/pacbio/1-5_combo/pero_pacbio_1-5_combo.fasta > ctg_pb.fasta

sed -i "s|MYCORES|${CORES}|g" split_and_run_pbdagcon.sh

sh ./split_and_run_pbdagcon.sh ../dbg2olc/backbone_raw.fasta  ../dbg2olc/DBG2OLC_Consensus_info.txt ctg_pb.fasta ./consensus_dir >consensus_log.txt 


#./DBG2OLC_Linux k 17 KmerCovTh 2 MinOverlap 20 AdaptiveTh 0.002 LD1 0 MinLen 200 Contigs plat_assembly_contig.fa RemoveChimera 1 f 30cell_arabidopsis_pb.fa 
