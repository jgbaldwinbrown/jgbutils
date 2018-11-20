#!/bin/bash
#$ -N bwa_pilon_1
#$ -pe openmp 32-64
#$ -R y
#$ -q bio,pub64,abio,free64,free48
#$ -ckpt restart

cd $SGE_O_WORKDIR



module load jje/jjeutils/0.1a

module load samtools/1.3
module load perl
module load bwa/0.7.8

./run_bwape.sh -g infasta.fasta -t ${CORES} -l /bio/jbaldwi1/all_data_from_dfs2/peromyscus_data/data/illumina/combo/split/pero -o .
#for lib in SRR097732 SRR210905 SRR306608 SRR350908;
#do
#    ./run_bwase.sh -g infasta.fasta -t ${CORES} -l /bio/jbaldwi1/dbg2olc/mel/pilon/data/${lib} -s 2 -o .
#done
