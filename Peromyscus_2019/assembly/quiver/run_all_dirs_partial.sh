homepwd=`pwd`

count=0
cat to_quiver.txt | while read line
do
    workdir=`dirname ${line} | cut -c 2-`
    mkdir -p $workdir
    cd $workdir && \
    temphome=`pwd` && \
    mkdir ref
    rsync -avP ${line} ref/ref.fasta && \
    rsync -avP ${homepwd}/template2/* . && \
    cd ref && \
    samtools faidx ref.fasta && \
    cd ${temphome} && \
    #rsync -avP ${homepwd}/cell_lists/fofn_lists/pero_fofn_list.txt ./fofn_list.txt && \
    find . -type f -name '*.sh' -o -type f -name '*.py' | while read line
    do
        sed -i "s|ASSEMBLYNUM|${count}|g" ${line}
    done &&\
    python make_pbalign_script_qmerged.py && \
    cd quiver_outfiles/align_qsubs && \
    ls -1 qsub_m* | while read line2
    do
        align_outfile=`echo "\`cut -c 6- <(echo $line2)\`.cmp.h5"`
        align_outpath=../align_out/${align_outfile}
        #echo "align_outfile: "${align_outfile}
        #echo "align_outpath: "${align_outpath}
        if ! [ -f $align_outpath ] || ! [ -s $align_outpath ]
        then
            #qsub ${line2}
            echo ${line2}
        fi
    done && \
    cd ${temphome} # && \
    #qsub pbmerge_shrimp_hybrid.sh && \
    #qsub quiver.sh
    cd ${homepwd}
    (( count++ ))
done

