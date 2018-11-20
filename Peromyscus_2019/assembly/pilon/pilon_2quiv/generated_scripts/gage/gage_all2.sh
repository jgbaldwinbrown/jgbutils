#!/bin/bash
#$ -N gage_pilon_1
#$ -pe openmp 1
#$ -R N
#$ -q bio,pub64,pub8i
###$ -t 1-22
###$ -ckpt restart
###$ -hold_jid pilon_1

# Go to the directory from which the job was launched.
cd $SGE_O_WORKDIR

export PATH=/bio/jbaldwi1/dbg2olc/mel/gage_validation/new_version:$PATH
module load MUMmer
module load perl
module load java

#job=$SGE_TASK_ID

rsync -avP ../pilon.fasta .

getCorrectnessStats.sh /dfs1/bio/jbaldwi1/dbg2olc/mel/reference/dmel-all-chromosome-r6.01.fasta pilon.fasta pilon.fasta 1> gage_out.txt 2> gage_err.txt



