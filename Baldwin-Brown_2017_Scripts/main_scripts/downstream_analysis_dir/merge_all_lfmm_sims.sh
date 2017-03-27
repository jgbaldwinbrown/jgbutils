myhome=`pwd`
lfmm_sim_home=/home/jbaldwin/new_home/wild_shrimp_data/for_shrimp_paper_1/bwa_alignments/snp_tables/deduped/new_downsampled/full_fst_dsbig_fused/bayenv_5repavg/v4_full_data_fixedinput_splitout/lfmm_sims/

#python -c "print '\n'.join(map(str,range(0,20,1)))" | xargs -i -P 4 paste {}/snp_freqmat_sim_split09.K9.{}_s*.9.zscore

for i in {1..20}
do
    #k=`echo $i | python -c 'import sys; a=sys.stdin.readlines()[0]; print "%02d" % (int(a),)'
    flist=`for j in {1..24} ; do echo ${lfmm_sim_home}/${i}/snp_freqmat_sim_split.K9.${i}_s${j}.9.zscore ; done`
    echo $flist | xargs paste > ${lfmm_sim_home}/${i}/snp_freqmat_sim_split.K9.${i}.combo.zscore
done

flist2=`for i in {1..20} ; do echo ${lfmm_sim_home}/${i}/snp_freqmat_sim_split.K9.${i}.combo.zscore ; done`

echo $flist2 | xargs cat > ${myhome}/lfmm_sim_full_combo.zscore

