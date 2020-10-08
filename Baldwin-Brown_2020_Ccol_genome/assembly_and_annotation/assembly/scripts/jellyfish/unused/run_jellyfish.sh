#!/bin/bash
#$ -N jelly_pero
#$ -pe openmp 64
#$ -R Y
#$ -q bio,pub64,adl

# Go to the directory from which the job was launched.
cd $SGE_O_WORKDIR

module load jellyfish

jellyfish count -m 21 -s 3000M -t 64 -o tiger_ill_mer_counts.jf -C <(zcat /share/adl/jbaldwi1/tiger_shrimp_data/data/fastqjoin_out/run1_noclip/Tiger180bp_L1_0712_R1.join.fq.gz) <(zcat /share/adl/jbaldwi1/tiger_shrimp_data/data/fastqjoin_out/run1_noclip/Tiger180bp_L1_0817_R1.join.fq.gz) <(zcat /share/adl/jbaldwi1/tiger_shrimp_data/data/fastqjoin_out/run1_noclip/Tiger180bp_L1_0920_R1.join.fq.gz) <(zcat /share/adl/jbaldwi1/tiger_shrimp_data/data/fastqjoin_out/run1_noclip/Tiger180bp_L1b_0920_R1.join.fq.gz) <(zcat /share/adl/jbaldwi1/tiger_shrimp_data/data/fastqjoin_out/run1_noclip/Tiger180bp_L2_0817_R1.join.fq.gz) <(zcat /share/adl/jbaldwi1/tiger_shrimp_data/data/fastqjoin_out/run1_noclip/Tiger180bp_L6_0712_R1.join.fq.gz) <(zcat /share/adl/jbaldwi1/tiger_shrimp_data/data/fastqjoin_out/run1_noclip/Tiger180bp_L6b_0712_R1.join.fq.gz) <(zcat /share/adl/jbaldwi1/tiger_shrimp_data/data/fastqjoin_out/run1_noclip/Tiger180bp_L7_0622_R1.join.fq.gz) <(zcat /share/adl/jbaldwi1/tiger_shrimp_data/data/fastqjoin_out/run1_noclip/Tiger180bp_L7_0712_R1.join.fq.gz) <(zcat /share/adl/jbaldwi1/tiger_shrimp_data/data/fastqjoin_out/run1_noclip/Tiger180bp_L7b_0622_R1.join.fq.gz) <(zcat /share/adl/jbaldwi1/tiger_shrimp_data/data/fastqjoin_out/run1_noclip/Tiger180bp_L8_0712_R1.join.fq.gz)
#64 threads, 3 billion hash elements, 21mers.

jellyfish histo tiger_ill_mer_counts.jf

jellyfish dump tiger_ill_mer_counts.jf > tiger_ill_mer_counts_dumps.fa
