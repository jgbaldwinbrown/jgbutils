#!/bin/bash
#$ -N quickmerge
#$ -pe openmp 1
##$ -R y
#$ -q bio,som,pub64,abio,free64,free48
#$ -ckpt restart
###$ -l kernel=blcr
###$ -r y
##$ -hold_jid dbg2olc_analysis_10_casey

cd $SGE_O_WORKDIR

#module load wgs
#module load MUMmer/3.23
#module load amos
#module load boost/1.49.0
#module load Blat
#module load perl/5.16.2
#module load python/2.7.2

#/bio/jbaldwi1/dbg2olc/mel/self_assemblies/merged_v2_fixed/quickmerge/merger

export PATH=$PATH:/bio/jbaldwi1/peromyscus/work/merge/merge/quickmerge/merger
export PATH=$PATH:/bio/jbaldwi1/peromyscus/work/merge/merge/mummer_v4_debug/MUMmer3.23

#export PATH=$PATH:/bio/jbaldwi1/programs/quast/quast-2.3

home=/bio/jbaldwi1/all_data_from_dfs2/peromyscus_data/work/merge/merge_falcon

python merge_wrapper.py ${home}/hybrid/final_assembly.fasta ${home}/falcon/p_ctg.fa -l 10000 1> merge_out.txt 2> merge_err.txt

perl find_n50_2.pl merged.fasta > n50.txt
