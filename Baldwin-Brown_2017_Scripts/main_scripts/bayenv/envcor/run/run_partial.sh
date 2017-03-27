#!/bin/bash

rootdir=`pwd`

cd all_run_dir
allrundir=`pwd`

#find $PWD -name 'run_bayenv_pop_differentiation_parallel.sh' | sort #debug
find $PWD -name 'run_bayenv_pop_differentiation_parallel.sh'  | grep -v popdif | grep -v pooled | sort | while read line
do
    rundir=`dirname ${line}`
    cd ${rundir} && \
    #pwd #debug

    outfile_to_check=`find $PWD -type f | grep -E "bf|envir|XtX" | sort | head -1`
    snpsfile=`cat run_bayenv_pop_differentiation_parallel.sh | grep "SNPFILE=" | grep -vE '^#' | cut -d '=' -f 2`
    numsnplines=`wc -l ${snpsfile} | cut -d ' ' -f 1`
    numsnps=`echo "${numsnplines} / 2" | bc`

    mv --backup=t to_do.txt to_do_old.txt
    cp --backup=t run_bayenv_pop_differentiation_parallel.sh run_bayenv_pop_differentiation_parallel_old.sh

    python get_inverse_nums.py ${outfile_to_check} ${numsnps} > to_do.txt
    numsnpsleft=`wc -l to_do.txt | python -c 'import sys; [sys.stdout.write(line.split()[0]) for line in sys.stdin]'`
    chunksize=`python -c "from math import ceil; print int(ceil(${numsnpsleft}/1000.0))"`

    sed -i 's/^endpos=.*/endpos=`echo "\$\{SGE_TASK_ID\} \* '${chunksize}'" | bc`/' run_bayenv_pop_differentiation_parallel.sh
    sed -i 's/^startpos=.*/startpos=`echo "\$\{endpos\} - \('${chunksize}' - 1\)" | bc`/' run_bayenv_pop_differentiation_parallel.sh

    qsub run_bayenv_pop_differentiation_parallel.sh

    echo rundir=${rundir}
    echo outfile_to_check=${outfile_to_check}
    echo snpsfile=${snpsfile}
    echo numsnplines=${numsnplines}
    echo numsnps=${numsnps}
    echo numsnpsleft=${numsnpsleft}
    echo chunksize=${chunksize}
    echo allrundir=${allrundir}
    echo line=${line}

    cd ${allrundir}
done

cd ${rootdir}

