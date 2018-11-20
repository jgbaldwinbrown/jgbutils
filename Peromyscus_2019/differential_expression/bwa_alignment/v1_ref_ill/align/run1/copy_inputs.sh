#!/bin/bash
#$ -N copy
#$ -q adl,bio,pub64
#$ -ckpt restart
#$ -hold_jid trimmomatic

cat ../../dedup_and_trim/trimmed/*READ1* > data/raw/indata_READ1.fq.gz
cat ../../dedup_and_trim/trimmed/*READ2* > data/raw/indata_READ2.fq.gz

#cp /bio/jbaldwi1/shrimp_data/illumina_data_2/dedup_and_trim/trimmed/R111-L6-READ1-Sequences_prinseq_good_M9PO.fastq.gz_paired.fq.gz /bio/jbaldwi1/shrimp_data/illumina_data_2/align/final_assembly/run1/data/raw/shrimp_inbred_ill2_clipped_R1.fq.gz
#cp /bio/jbaldwi1/shrimp_data/illumina_data_2/dedup_and_trim/trimmed/R111-L6-READ2-Sequences_prinseq_good_8qZQ.fastq.gz_paired.fq.gz /bio/jbaldwi1/shrimp_data/illumina_data_2/align/final_assembly/run1/data/raw/shrimp_inbred_ill2_clipped_R2.fq.gz

#/bio/jbaldwi1/shrimp_data/illumina_data_2/dedup_and_trim/trimmed/R111-L6-READ1-Sequences_prinseq_good_M9PO.fastq.gz_paired.fq.gz
#/bio/jbaldwi1/shrimp_data/illumina_data_2/dedup_and_trim/trimmed/R111-L6-READ2-Sequences_prinseq_good_8qZQ.fastq.gz_paired.fq.gz
