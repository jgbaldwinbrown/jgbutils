#!/bin/bash
#$ -N pbmer_2
#$ -q bio,pub64,abio,free64
#$ -l mem_size=512
#$ -ckpt restart
#$ -hold_jid quiver_align_2
module load smrtanalysis/2.2.0p3

homepwd=`pwd`

#cd quiver_outfiles/align_out

all_files=`ls -1 quiver_outfiles/align_out | while read line ; do echo quiver_outfiles/align_out/${line} ; done | tr '\n' ' '`

cmph5tools.py merge --outFile quiver_outfiles/merged_cmp/shrimp_qmerged_all.cmp.h5 ${all_files}
cmph5tools.py sort --tmpDir /fast-scratch/jbaldwi1/ --deep quiver_outfiles/merged_cmp/shrimp_qmerged_all.cmp.h5


