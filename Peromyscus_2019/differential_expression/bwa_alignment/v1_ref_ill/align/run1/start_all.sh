myhome=`pwd`
#qsub copy_inputs.sh
#qsub indexer.sh
qsub prep_vcf2.sh
##qsub merge_bam.sh
##cd dedup && qsub split_dedup_and_merge_v3.sh
##cd $myhome
qsub make_vcf.sh
qsub make_snptable.sh
#qsub make_vcf_snpsonly.sh
#qsub make_snptable_snpsonly.sh
###./index_rgbam.sh
###./run_snptable.sh
