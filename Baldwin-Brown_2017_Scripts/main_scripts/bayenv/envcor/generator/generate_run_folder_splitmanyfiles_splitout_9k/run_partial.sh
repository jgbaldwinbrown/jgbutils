#!/bin/bash

rootdir=`pwd`

cd all_run_dir
allrundir=`pwd`

#find $PWD -name 'run_bayenv_pop_differentiation_parallel.sh' | sort #debug
find $PWD -name 'run_bayenv_pop_differentiation_parallel.sh'  | grep -v popdif | sort | while read line
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
    chunksize=`python -c "from math import ceil; print int(ceil(${numsnpsleft}/9000.0))"`

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

#numpops_array=( 11 12 )
#
#scheme_array=( standard downsampled )
#
#mode_array=( nonparametric pooled )
#
#snpsfiles=(  )
#
#envfiles=( /bio/jbaldwi1/all_data_from_dfs2/shrimp_data/bayenv/scripts/envcor/envfile/normalized_transposed_tank_info_11pop.txt
#/bio/jbaldwi1/all_data_from_dfs2/shrimp_data/bayenv/scripts/envcor/envfile/normalized_transposed_tank_info.txt )
#
#envfilesplitprefixes=( /bio/jbaldwi1/all_data_from_dfs2/shrimp_data/bayenv/scripts/envcor/envfile/split/11pop/splitenvfile_11pop
#/bio/jbaldwi1/all_data_from_dfs2/shrimp_data/bayenv/scripts/envcor/envfile/normalized_transposed_tank_info.txt )
#
#matfiles=( /bio/jbaldwi1/all_data_from_dfs2/shrimp_data/bayenv/scripts/cov_mat_generation/downsampled/11pop/shrimp_matrix_11_downsampled_final.txt
#/bio/jbaldwi1/all_data_from_dfs2/shrimp_data/bayenv/scripts/cov_mat_generation/downsampled/12pop/shrimp_matrix_12_downsampled_final.txt
#/bio/jbaldwi1/all_data_from_dfs2/shrimp_data/bayenv/scripts/cov_mat_generation/standard/11pop/shrimp_matrix_11_standard_final.txt
#/bio/jbaldwi1/all_data_from_dfs2/shrimp_data/bayenv/scripts/cov_mat_generation/standard/12pop/shrimp_matrix_12_standard_final.txt )

#numpops=${1}
#numsnps=${2}
#snpfile=${3}
#matfile=${4}
#envfile=${5}

#chunksize=`python -c "from math import ceil; print ceil(${numsnps}/1000.0)"`

#rootdir=`pwd`
#mkdir run_dir

#rsync -avP /bio/jbaldwi1/all_data_from_dfs2/shrimp_data/bayenv/scripts/envcor/generate_run_folder/template/* run_dir

#cd run_dir
#rundir=`pwd`
#find . -type f | while read line ; do sed -i "s|MYNUMPOPS|${numpops}|g" ${line} ; done
#find . -type f | while read line ; do sed -i "s|MYSNPFILE|${snpfile}|g" ${line} ; done
#find . -type f | while read line ; do sed -i "s|MYMATFILE|${matfile}|g" ${line} ; done
#find . -type f | while read line ; do sed -i "s|MYENVFILE|${envfile}|g" ${line} ; done
#find . -type f | while read line ; do sed -i "s|MYCHUNKSIZE|${chunksize}|g" ${line} ; done

####################################################################

#cd standard && \
#python make_todo.py ${numsnps} > to_do.txt && \
#if ! [ -f "primary_rseed.txt" ] && ! [ -s "primary_rseed.txt" ] && ! [ -f "rseeds.txt" ] && ! [ -s "rseeds.txt" ]
#then
#    rseed=$RANDOM && \
#    echo "$rseed" > primary_rseed.txt && \
#    python make_random_seeds.py $rseed $numsnps > rseeds.txt
#fi && \
#find . -type f | while read line ; do sed -i "s|MYBEMETHOD|standard|g" ${line} ; done

######################################################################

#cd ${rundir}/nonparametric
#python make_todo.py ${numsnps} > to_do.txt && \
#if ! [ -f "primary_rseed.txt" ] && ! [ -s "primary_rseed.txt" ] && ! [ -f "rseeds.txt" ] && ! [ -s "rseeds.txt" ]
#then
#    rseed=$RANDOM && \
#    echo "$rseed" > primary_rseed.txt && \
#    python make_random_seeds.py $rseed $numsnps > rseeds.txt
#fi && \
#find . -type f | while read line ; do sed -i "s|MYBEMETHOD|nonparametric|g" ${line} ; done
#
######################################################################
#
#cd ${rundir}/pooled
#python make_todo.py ${numsnps} > to_do.txt && \
#if ! [ -f "primary_rseed.txt" ] && ! [ -s "primary_rseed.txt" ] && ! [ -f "rseeds.txt" ] && ! [ -s "rseeds.txt" ]
#then
#    rseed=$RANDOM && \
#    echo "$rseed" > primary_rseed.txt && \
#    python make_random_seeds.py $rseed $numsnps > rseeds.txt
#fi
#find . -type f | while read line ; do sed -i "s|MYBEMETHOD|pooled|g" ${line} ; done
#
######################################################################
#
#cd ${rootdir}

