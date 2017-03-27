#!/bin/bash

rootdir=`pwd`

cd all_run_dir
allrundir=`pwd`

#find $PWD -name 'run_bayenv_pop_differentiation_parallel.sh' | sort #debug
find $PWD -name 'run_bayenv_pop_differentiation_parallel.sh' | grep -v popdif | grep -v pooled | sort | while read line
do
    rundir=`dirname ${line}`
    cd ${rundir} && \
    #pwd #debug
    qsub run_bayenv_pop_differentiation_parallel.sh
    cd ${allrundir}
done

cd ${rootdir}

