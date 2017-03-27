#!/bin/bash
#$ -N lfmm
#$ -q bio,abio,free64,pub64,free48
#$ -ckpt restart
#$ -pe openmp 16-64
#$ -t 1-240

export PATH=$PATH:/bio/jbaldwi1/programs/lfmm/LFMM_CL_v1.4/bin

home=`pwd`

genofile=/bio/jbaldwi1/all_data_from_dfs2/shrimp_data/lfmm/data/freqmats/dsbig_nofuse/cens/dsbig_snp_freqmat_fused_cens.txt
env_variable_file=/bio/jbaldwi1/all_data_from_dfs2/shrimp_data/lfmm/data/envmats/normalized_tank_info_noanc.txt
#numlatents=${3}
numprocs=${CORES}
seedfile=rseeds.txt
iters=10000
burns=5000
outprefix=`basename ${genofile}`
#num_env_vars=`head -1 ${env_variable_file} | wc -w | tr -d '\n' | tr -d ' '`
num_env_vars=24
numreps=10

if [ ! -s ${seedfile} ]
    then
    python -c 'import sys
import random
for i in xrange(1000000):
    print random.randrange(0,100000000)' > ${seedfile}
fi

i=9
j=`echo "(${SGE_TASK_ID} % 10) + 1" | bc`
k=`echo "(${SGE_TASK_ID} / 10) + 1" | bc`
#i=$SGE_TASK_ID
myseedpos=${SGE_TASK_ID}
#j=1
#for i in {1..10}
#do
#    for j in {1..3}
#    do

#        oldmyseedpos=$myseedpos
#        myseedpos=`echo "${oldmyseedpos}+1" | bc`
        myseed=`head -n ${myseedpos} ${seedfile} | tail -n 1 | tr -d '\n'`
        mkdir -p ${i}/${j}
        cd ${i}/${j} && \
        #LFMM -x ${genofile} -v ${env_variable_file} -K ${i} -p ${numprocs} -b ${burns} -i ${iters} -m ${missing_data} -o ${outprefix}.K${i}.${j} -s ${myseed}
        LFMM -x ${genofile} -v ${env_variable_file} -K ${i} -p ${numprocs} -b ${burns} -i ${iters} -m -s ${myseed} -d ${k} -o ${outprefix}.K${i}.${j}
        cd ${home}
#    done
#done

