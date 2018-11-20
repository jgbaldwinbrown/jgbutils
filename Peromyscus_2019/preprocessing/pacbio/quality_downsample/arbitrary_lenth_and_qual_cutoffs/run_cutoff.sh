#!/bin/bash
#$ -N cut_pero
#$ -pe openmp 1
###$ -R Y
#$ -q bio,pub64
#$ -ckpt restart
###$ -t 1-60

# Go to the directory from which the job was launched.
cd $SGE_O_WORKDIR

#python full_quality_cutoff_pero.py
python cutoff_by_length_and_quality.py quality_and_length_list_pero_1-18.txt 2000 0.85 > pero_1-18combo_2klen_.85q_.fastq
