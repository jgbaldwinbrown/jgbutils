#!/bin/bash
#$ -N dbg2olc_hum_54x
#$ -pe openmp 1
#$ -R N
#$ -q bio,pub64

# Go to the directory from which the job was launched.
cd $SGE_O_WORKDIR

#/dfs1/bio/jbaldwi1/programs/dbg2olc/Programs

./DBG2OLC_Linux k 17 KmerCovTh 2 MinOverlap 20 AdaptiveTh 0.002 LD1 0 MinLen 200 Contigs /bio/jbaldwi1/dbg2olc_from_dfs2/human/plat_assembly_contig.fa RemoveChimera 1 f /bio/jbaldwi1/dbg2olc_from_dfs2/human/dbg2olc_54x/data2/downsample_30x/human_filtered_30x_longest.fastq
