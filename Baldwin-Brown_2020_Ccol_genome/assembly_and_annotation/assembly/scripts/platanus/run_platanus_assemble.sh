#!/bin/bash
#$ -N plat_tig
#$ -pe openmp 64
#$ -R Y
#$ -q bio,som
#$ -ckpt restart

#cd $SGE_O_WORKDIR

#PATH=$PATH:/bio/jbaldwi1/programs/platanus_1.2.1/v2

platanus assemble -t 32 -f $(find temp/fqjoin -type f -name '*raw*.fq' | sort) -o temp/platanus/platanus_louse_assembly -m 512 1> temp/platanus/plat_assembly_out.txt 2> temp/platanus/plat_assembly_err.txt

