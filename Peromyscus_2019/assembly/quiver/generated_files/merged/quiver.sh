#!/bin/bash
#$ -N quiver_2
#$ -q bio,som
#$ -pe openmp 32-64 
#$ -hold_jid pbmer_2
#$ -ckpt restart

#module load  python/3.2.2 
module load enthought_python
module load boost
module load smrtanalysis/2.2.0p3


#pbalign.py --nproc 32 --forQuiver /share/jje/mchakrab/pacbio/bergaman/self_a1/quiver/71401.fofn /share/jje/mchakrab/pacbio/bergaman/self_a1/selfcor1/9-terminator/asm.ctg.fasta /share/jje/mchakrab/pacbio/bergaman/self_a1/quiver/71401.cmp.h5

rootdir=`pwd`
ID=${rootdir}/quiver_outfiles/merged_cmp
REF=${rootdir}/ref/ref.fasta
OD=${rootdir}/quiver_outfiles/quiver_out

#ID=/bio/jbaldwi1/dbg2olc/mel/quiver/ASSEMBLY_TYPE/CELLS/quiver_outfiles/merged_cmp
#REF=/bio/jbaldwi1/dbg2olc/mel/quiver/ASSEMBLY_TYPE/CELLS/ref/ref.fasta
#OD=/bio/jbaldwi1/dbg2olc/mel/quiver/ASSEMBLY_TYPE/CELLS/quiver_outfiles/quiver_out

rootname=shrimp_qmerged


quiver -j ${CORES} ${ID}/${rootname}_all.cmp.h5 -r ${REF} -o ${OD}/${rootname}.quiver.fasta -o ${OD}/${rootname}.quiver.fastq -o ${OD}/${rootname}.quiver.gff
