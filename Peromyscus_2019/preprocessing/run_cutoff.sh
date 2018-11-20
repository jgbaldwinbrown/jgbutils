#!/bin/bash
#$ -N cut_tiger
#$ -pe openmp 1
###$ -R Y
#$ -q bio,pub64
#$ -ckpt restart
###$ -t 1-60

# Go to the directory from which the job was launched.
cd $SGE_O_WORKDIR

python full_quality_cutoff_tiger.py
