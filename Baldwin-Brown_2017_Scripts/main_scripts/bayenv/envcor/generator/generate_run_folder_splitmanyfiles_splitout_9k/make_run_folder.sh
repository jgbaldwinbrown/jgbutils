#numpops=${1}
#numsnps=${2}
#snpfile=${3}
#matfile=${4}
#envfile=${5}

infile=`find $PWD -maxdepth 1 -name "${1}"`

rootdir=`pwd`
mkdir all_run_dir
cd all_run_dir

cat ${infile} | tail -n +2 | while IFS=$'\t' read -r -a myArray
do
    numpops=${myArray[0]}
    snpfile=${myArray[7]}
    matfile=${myArray[6]}
    poolmatfile=${myArray[8]}
    envfile=${myArray[4]}
    envprefix=${myArray[5]}
    scheme=${myArray[1]}
    mode=${myArray[2]}
    poly_type=${myArray[3]}
    
    basesnpfile=`basename ${snpfile}`
    basesnpfilenotxt=`basename ${snpfile} .txt | tr -d '\n'`
    basematfile=`basename ${matfile}`
    baseenvfile=`basename ${envfile}`
    baseenvprefix=`basename ${envprefix}`
    basepoolmatfile=`basename ${poolmatfile}`
    
    numsnplines=`wc -l ${snpfile} | cut -d ' ' -f 1`
    numsnps=`echo "${numsnplines} / 2" | bc`
    chunksize=`python -c "from math import ceil; print int(ceil(${numsnps}/9000.0))"`
    
    allrundir=`pwd`
    mkdir -p ${scheme}/${numpops}/${poly_type}
    cd ${scheme}/${numpops}/${poly_type}/ && \
    
    rsync -avP /share/adl/jbaldwi1/all_data_from_dfs2/shrimp_data/bayenv/scripts/envcor/v2/generate_run_folder_splitmanyfiles_splitout_9k/template/* .
              #/share/adl/jbaldwi1/all_data_from_dfs2/shrimp_data/bayenv/scripts/envcor/v2/generate_run_folder_splitmanyfiles_splitout_9k/template/nonparametric
    rundir=`pwd`
    find . -type f -name 'run*.sh' | while read line ; do sed -i "s|MYNUMPOPS|${numpops}|g" ${line} ; done
    find . -type f -name 'run*.sh' | while read line ; do sed -i "s|MYSNPFILE|${basesnpfile}|g" ${line} ; done
    find . -type f -name 'run*.sh' | while read line ; do sed -i "s|MYMATFILE|${basematfile}|g" ${line} ; done
    find . -type f -name 'run*.sh' | while read line ; do sed -i "s|MYENVFILE|${baseenvfile}|g" ${line} ; done
    find . -type f -name 'run*.sh' | while read line ; do sed -i "s|MYCHUNKSIZE|${chunksize}|g" ${line} ; done
    find . -type f -name 'run*.sh' | while read line ; do sed -i "s|MYPOOLENVPREFIX|${baseenvprefix}|g" ${line} ; done
    find . -type f -name 'run*.sh' | while read line ; do sed -i "s|MYNUMSNPS|${numsnps}|g" ${line} ; done
    find . -type f -name 'run*.sh' | while read line ; do sed -i "s|MYPOOLMATFILE|${basepoolmatfile}|g" ${line} ; done

    
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
    
    cd ${rundir}/nonparametric
    if ! [ -f "to_do.txt" ]
    then
        python make_todo.py ${numsnps} > to_do.txt
    fi && \
    if ! [ -f "primary_rseed.txt" ] && ! [ -f "rseeds.txt" ]
    then
        rseed=$RANDOM && \
        echo "$rseed" > primary_rseed.txt && \
        python make_random_seeds.py $rseed $numsnps > rseeds.txt
    fi && \
    find . -type f -name 'run*.sh' | while read line ; do sed -i "s|MYBEMETHOD|nonparametric|g" ${line} ; done
    
    rsync -avP ${matfile} .
    rsync -avP ${envfile} .
    rsync -avP ${envprefix}* .
    rsync -avP ${snpfile} .
    
    split -d -a 10 -l 90000 ${basesnpfile} ${basesnpfilenotxt}
    split -d -a 10 -l 90000 to_do.txt to_do
    split -d -a 10 -l 90000 rseeds.txt rseeds
    
    #####################################################################
    
    cd ${rundir}/pooled
    if ! [ -f "to_do.txt" ]
    then
        python make_todo.py ${numsnps} > to_do.txt
    fi && \
    if ! [ -f "primary_rseed.txt" ] && ! [ -f "rseeds.txt" ]
    then
        rseed=$RANDOM && \
        echo "$rseed" > primary_rseed.txt && \
        python make_random_seeds.py $rseed $numsnps > rseeds.txt
    fi
    find . -type f -name 'run*.sh' | while read line ; do sed -i "s|MYBEMETHOD|pooled|g" ${line} ; done
    
    rsync -avP ${matfile} .
    rsync -avP ${envfile} .
    rsync -avP ${envprefix}* .
    rsync -avP ${snpfile} .
    
    #####################################################################
    
    #cd ${rundir}/popdif
    #if ! [ -f "to_do.txt" ]
    #then
    #    python make_todo.py ${numsnps} > to_do.txt
    #fi && \
    #if ! [ -f "primary_rseed.txt" ] && ! [ -f "rseeds.txt" ]
    #then
    #    rseed=$RANDOM && \
    #    echo "$rseed" > primary_rseed.txt && \
    #    python make_random_seeds.py $rseed $numsnps > rseeds.txt
    #fi && \
    #find . -type f -name 'run*.sh' | while read line ; do sed -i "s|MYBEMETHOD|popdif|g" ${line} ; done
    #
    #rsync -avP ${matfile} .
    #rsync -avP ${envfile} .
    #rsync -avP ${envprefix}* .
    #rsync -avP ${snpfile} .
    
    #####################################################################

    #debug section:
    echo $numpops
    echo $snpfile
    echo $matfile
    echo $envfile
    echo $envprefix
    echo $scheme
    echo $mode
    echo $poly_type
    echo $numsnplines
    echo $numsnps
    echo $chunksize
    echo $allrundir
    echo $rundir
    
    cd ${allrundir}
    
done

cd ${rootdir}

