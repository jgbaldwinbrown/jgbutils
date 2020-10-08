#!/bin/bash
#$ -N copy
#$ -q adl,bio,pub64
#$ -ckpt restart
#$ -hold_jid trimmomatic

cat /share/adl/jbaldwi1/tiger_shrimp_data/data/fastqjoin_out/run1_noclip/Tiger180bp_L1_0712_R1.join.fq.gz /share/adl/jbaldwi1/tiger_shrimp_data/data/fastqjoin_out/run1_noclip/Tiger180bp_L1_0817_R1.join.fq.gz /share/adl/jbaldwi1/tiger_shrimp_data/data/fastqjoin_out/run1_noclip/Tiger180bp_L1_0920_R1.join.fq.gz /share/adl/jbaldwi1/tiger_shrimp_data/data/fastqjoin_out/run1_noclip/Tiger180bp_L1b_0920_R1.join.fq.gz /share/adl/jbaldwi1/tiger_shrimp_data/data/fastqjoin_out/run1_noclip/Tiger180bp_L2_0817_R1.join.fq.gz /share/adl/jbaldwi1/tiger_shrimp_data/data/fastqjoin_out/run1_noclip/Tiger180bp_L6_0712_R1.join.fq.gz /share/adl/jbaldwi1/tiger_shrimp_data/data/fastqjoin_out/run1_noclip/Tiger180bp_L6b_0712_R1.join.fq.gz /share/adl/jbaldwi1/tiger_shrimp_data/data/fastqjoin_out/run1_noclip/Tiger180bp_L7_0622_R1.join.fq.gz /share/adl/jbaldwi1/tiger_shrimp_data/data/fastqjoin_out/run1_noclip/Tiger180bp_L7_0712_R1.join.fq.gz /share/adl/jbaldwi1/tiger_shrimp_data/data/fastqjoin_out/run1_noclip/Tiger180bp_L7b_0622_R1.join.fq.gz /share/adl/jbaldwi1/tiger_shrimp_data/data/fastqjoin_out/run1_noclip/Tiger180bp_L8_0712_R1.join.fq.gz > data/raw/indata_all.fq.gz

#cat ../../dedup_and_trim/trimmed/*READ1* > data/raw/indata_READ1.fq.gz
#cat ../../dedup_and_trim/trimmed/*READ2* > data/raw/indata_READ2.fq.gz

#cp /bio/jbaldwi1/shrimp_data/illumina_data_2/dedup_and_trim/trimmed/R111-L6-READ1-Sequences_prinseq_good_M9PO.fastq.gz_paired.fq.gz /bio/jbaldwi1/shrimp_data/illumina_data_2/align/final_assembly/run1/data/raw/shrimp_inbred_ill2_clipped_R1.fq.gz
#cp /bio/jbaldwi1/shrimp_data/illumina_data_2/dedup_and_trim/trimmed/R111-L6-READ2-Sequences_prinseq_good_8qZQ.fastq.gz_paired.fq.gz /bio/jbaldwi1/shrimp_data/illumina_data_2/align/final_assembly/run1/data/raw/shrimp_inbred_ill2_clipped_R2.fq.gz

#/bio/jbaldwi1/shrimp_data/illumina_data_2/dedup_and_trim/trimmed/R111-L6-READ1-Sequences_prinseq_good_M9PO.fastq.gz_paired.fq.gz
#/bio/jbaldwi1/shrimp_data/illumina_data_2/dedup_and_trim/trimmed/R111-L6-READ2-Sequences_prinseq_good_8qZQ.fastq.gz_paired.fq.gz
#/share/adl/jbaldwi1/tiger_shrimp_data/data/fastqjoin_out/run1_noclip/Tiger180bp_L1_0712_R1.join.fq.gz /share/adl/jbaldwi1/tiger_shrimp_data/data/fastqjoin_out/run1_noclip/Tiger180bp_L1_0817_R1.join.fq.gz /share/adl/jbaldwi1/tiger_shrimp_data/data/fastqjoin_out/run1_noclip/Tiger180bp_L1_0920_R1.join.fq.gz /share/adl/jbaldwi1/tiger_shrimp_data/data/fastqjoin_out/run1_noclip/Tiger180bp_L1b_0920_R1.join.fq.gz /share/adl/jbaldwi1/tiger_shrimp_data/data/fastqjoin_out/run1_noclip/Tiger180bp_L2_0817_R1.join.fq.gz /share/adl/jbaldwi1/tiger_shrimp_data/data/fastqjoin_out/run1_noclip/Tiger180bp_L6_0712_R1.join.fq.gz /share/adl/jbaldwi1/tiger_shrimp_data/data/fastqjoin_out/run1_noclip/Tiger180bp_L6b_0712_R1.join.fq.gz /share/adl/jbaldwi1/tiger_shrimp_data/data/fastqjoin_out/run1_noclip/Tiger180bp_L7_0622_R1.join.fq.gz /share/adl/jbaldwi1/tiger_shrimp_data/data/fastqjoin_out/run1_noclip/Tiger180bp_L7_0712_R1.join.fq.gz /share/adl/jbaldwi1/tiger_shrimp_data/data/fastqjoin_out/run1_noclip/Tiger180bp_L7b_0622_R1.join.fq.gz /share/adl/jbaldwi1/tiger_shrimp_data/data/fastqjoin_out/run1_noclip/Tiger180bp_L8_0712_R1.join.fq.gz 
