#!/bin/bash
#$ -N qtest_shrimp
#$ -pe openmp 32-64
#$ -R y
#$ -q bio,abio,free64,pub64
#$ -ckpt blcr

cd $SGE_O_WORKDIR

#module load wgs
#module load MUMmer/3.23
#module load amos
#module load boost/1.49.0
#module load Blat
#module load perl/5.16.2
#module load R
module load python
module load jellyfish
module load quake/0.3-800bp

#export PATH=$PATH:/gl/bio/jbaldwi1/programs/quake/Quake/bin
# choose your own your_library_prefix, and set name_of_illumina_fq_file to your Illumina file's name

#gunzip -c /gl/bio/jbaldwi1/yak_pacbio_from_kevin/illumina/line0_lane2_1.fastq > line0_lane2_1_quaked.fastq

./quake.py -f /dfs2/temp/bio/jbaldwi1/peromyscus_data/work/quake/to_quake_list.txt -k 19 -p 64 -q 33
