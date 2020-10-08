#!/bin/bash
#$ -N dbg2olc_gage_hum_54x
#$ -pe openmp 1
#$ -R N
#$ -q bio,pub64,pub8i
###$ -t 1-22
###$ -ckpt restart
###$ -hold_jid dbg2olc_consensus_hum_54x

# Go to the directory from which the job was launched.
cd $SGE_O_WORKDIR

export PATH=/bio/jbaldwi1/dbg2olc/mel/gage_validation/new_version:$PATH
module load MUMmer
module load perl
module load java

#job=$SGE_TASK_ID

rsync -avP ../final_assembly.fasta .

getCorrectnessStats.sh /bio/jbaldwi1/dbg2olc_from_dfs2/human/dbg2olc_54x/ref/GRCh38.p7/GCA_000001405.22_GRCh38.p7_genomic.fna final_assembly.fasta final_assembly.fasta 1> gage_out.txt 2> gage_err.txt



