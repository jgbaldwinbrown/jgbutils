#!/bin/bash
#$ -N canu_pero
#$ -q bio,som


#export PATH=/dfs1/bio/jbaldwi1/programs/canu/canu-master/Linux-amd64/bin:$PATH


module load canu

export PERL5LIB=/bio/jbaldwi1/all_data_from_dfs2/peromyscus_data/work/canu/perl_modules_needed/filesys-df/Filesys-Df-0.92/lib64/perl5/Filesys

canu \
 -p peromyscus -d pero_auto \
 genomeSize=2.6g \
 useGrid=1 \
 gridEngineThreadsOption='-pe openmp THREADS' \
 gridOptions='-q bio,som,pub64,pub8i' \
 -pacbio-raw /bio/jbaldwi1/all_data_from_dfs2/peromyscus_data/data/pacbio/1-18_combo/pero_combo_1-18_v2.fastq

#canu \
# -p peromyscus -d pero_auto \
# genomeSize=2.6g \
# useGrid=1 \
# gridEngineThreadsOption='-pe openmp THREADS' \
# gridEngineMemoryOption='-l mem_size=MEMORY' \
# gridOptions='-q bio,som,pub64,pub8i' \
# -pacbio-raw /bio/jbaldwi1/all_data_from_dfs2/peromyscus_data/data/pacbio/1-18_combo/pero_combo_1-18_v2.fastq


