#!/bin/bash
#$ -N pero_pbcr
#$ -q bio,pub64,som
#$ -pe openmp 32 
###$ -ckpt blcr
###$ -l kernel=blcr


module load amos
module load smrtanalysis/02.2.0p3 
module load java/1.8

PATH=$PATH:/dfs1/bio/mchakrab/pacbio/wgs-8.3rc1/Linux-amd64/bin/
export PATH

PBcR -l human -s pacbio.spec -noclean -fastq /dfs2/temp/bio/jbaldwi1/peromyscus_data/data/pacbio/1-18_combo/pero_combo_1-18_v2.fastq genomeSize=2600000000 localStaging=/dfs2/temp/bio/jbaldwi1/peromyscus_data/work/pbcr/trial_3_12-16-15/temp_files/
