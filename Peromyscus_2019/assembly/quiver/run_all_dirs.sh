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
    #rsync -avP ${homepwd}/cell_lists/fofn_lists/pero_fofn_list.txt ./fofn_list.txt && \
    find . -type f -name '*.sh' -o -type f -name '*.py' | while read line
    do
        sed -i "s|ASSEMBLYNUM|${count}|g" ${line}
    done &&\
    python make_pbalign_script_qmerged.py && \
    cd quiver_outfiles/align_qsubs && \
    ls -1 qsub_m* | while read line2 ; do qsub ${line2} ; done && \
    cd ${temphome} # && \
    qsub pbmerge_shrimp_hybrid.sh && \
    qsub quiver.sh
    cd ${homepwd}
    (( count++ ))
done

