myhome=`pwd`
sweed_sim_home=/home/jbaldwin/new_home/wild_shrimp_data/for_shrimp_paper_1/bwa_alignments/snp_tables/deduped/new_downsampled/full_fst_dsbig_fused/bayenv_5repavg/v4_full_data_fixedinput_splitout/sweed_sims/


flist=`find $PWD -name '*Report*' | grep -v 'nohead' | sort`
echo $flist | tr ' ' '\n' | while read i ; do tail -n +4 $i > ${i}.nohead ; done
flist2=`find $PWD -name '*Report*' | grep 'nohead' | sort`
echo $flist2 | tr ' ' '\n' | xargs cat > ${myhome}/sweed_sim_full_combo.txt


