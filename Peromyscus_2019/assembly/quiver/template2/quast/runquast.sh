#!/bin/bash
#$ -N quast_ASSEMBLYNUM
#$ -pe openmp 32-64
##$ -R y
#$ -q bio,pub64,abio,free64
#$ -ckpt restart
###$ -l kernel=blcr
###$ -r y
#$ -hold_jid quiver_ASSEMBLYNUM

cd $SGE_O_WORKDIR

module load wgs
module load MUMmer/3.23
module load amos
module load boost/1.49.0
module load Blat
module load perl/5.16.2
module load python/2.7.2

export PATH=$PATH:/dfs1/bio/jbaldwi1/programs/quast/quast-2.3

cp ../quiver_outfiles/quiver_out/shrimp_qmerged.quiver.fasta .

python /dfs1/bio/jbaldwi1/programs/quast/quast-2.3/quast.py shrimp_qmerged.quiver.fasta --debug -t $CORES 1> quast_out.txt 2> quast_err.txt
