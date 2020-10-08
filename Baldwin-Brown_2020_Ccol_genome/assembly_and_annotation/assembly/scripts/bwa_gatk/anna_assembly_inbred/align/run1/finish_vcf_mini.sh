#!/bin/bash

##add paths to files
HOMEPATH=temp/bwa_gatk/anna_assembly_inbred/align/run1/
MAINPATH=data/raw/
REFPATH=${HOMEPATH}/ref/ALM_F2Male_MDS349_CLCassembly.fasta
BWATEMPPATH=${HOMEPATH}/data/bwa_temp/

picardpath=/data1/jbrown/local_programs/picard/picard.jar
gatkpath=/data1/jbrown/local_programs/gatk/GenomeAnalysisTK.jar
##add array of filenames

PREFIX=louse_inbred_180_500

java -d64 -Xmx128g -Djava.io.tmpdir=${PWD}/tmp -jar $gatkpath -T VariantFiltration -R ${REFPATH} -V ${HOMEPATH}/data/gatk/rawSNPS-Q30-annotated.vcf --mask ${HOMEPATH}/data/gatk/inDels-Q30.vcf --maskExtension 5 --maskName InDel --clusterWindowSize 10 --filterExpression "MQ0 >= 4 && ((MQ0 / (1.0 * DP)) > 0.1)" --filterName "BadValidation" --filterExpression "QUAL < 30.0" --filterName "LowQual" --filterExpression "QD < 5.0" --filterName "LowVQCBD" --filterExpression "FS > 60" --filterName "FisherStrand" -o ${HOMEPATH}/data/gatk/Q30-SNPs.vcf
cat ${HOMEPATH}/data/gatk/Q30-SNPs.vcf | grep 'PASS\|^#' > ${HOMEPATH}/data/gatk/only-PASS-Q30-SNPs.vcf
