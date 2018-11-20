#!/bin/bash
#$ -N pilon
#$ -t 1-
#$ -pe openmp 8-64
#$ -ckpt restart
#$ -q bio,abio,free48,pub64,pub8i

#job=$SGE_TASK_ID
#for job in {1..3}
for job in 1
do
    infile=`head -n ${job} all_files_to_pilon.txt | tail -n 1`
    
    outpath=`echo ${infile} | python cut_path.py`
    
    echo ${outpath} | python make_dirs_for_run.py
    
    homepwd=`pwd`
    cd ${outpath} && \
    rsync -avP $infile ./infasta.fasta && \
    rsync -avP ${homepwd}/template/* . && \
    find . -type f -name '*.s' | while read line ; do sed "s|JOBNUM|${job}|g" ${line} > ${line}h ; done && \
    ###mkdir bwa_output && \
    qsub run_bwa_on_files.sh && \
    qsub run_pilon.sh && \
    temppwd=`pwd` && \
    cd quast2 && \
    qsub runquast.sh && \
    cd ${temppwd}/quast3 && \
    qsub runquast.sh && \
    cd ${temppwd}/gage # &&\
    qsub gage_all2.sh
    cd ${homepwd}
done
