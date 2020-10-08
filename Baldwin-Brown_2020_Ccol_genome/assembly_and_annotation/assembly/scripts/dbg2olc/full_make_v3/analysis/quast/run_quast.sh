#!/bin/bash
#$ -N quast_hum_54x
#$ -pe openmp 64
##$ -R y
#$ -q bio,pub64
###$ -ckpt blcr
###$ -l kernel=blcr
###$ -r y
#$ -hold_jid dbg2olc_analysis_hum_54x

cd $SGE_O_WORKDIR

module load wgs
module load MUMmer/3.23
module load amos
module load boost/1.49.0
module load Blat
module load perl/5.16.2
module load python/2.7.2
module load jbaldwi1/quast/2.3/2015.8.25

#export PATH=$PATH:/dfs1/bio/jbaldwi1/programs/quast/quast-2.3

python quast.py ../final_assembly.fasta --debug -t 64 -R /bio/jbaldwi1/dbg2olc_from_dfs2/human/dbg2olc_54x/ref/GRCh38.p7/GCA_000001405.22_GRCh38.p7_genomic.fna 1> quast_out.txt 2> quast_err.txt
