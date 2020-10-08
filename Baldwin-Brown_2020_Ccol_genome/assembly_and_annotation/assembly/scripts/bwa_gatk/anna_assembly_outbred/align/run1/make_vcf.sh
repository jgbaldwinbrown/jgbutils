#!/bin/bash
#$ -N MAKEVCF
#$ -q bio,pub64,adl
#$ -pe openmp 16
#$ -R y
#$ -hold_jid PREPVCF
#module load enthought_python
#module load java/1.7
#module load bwa
#module load samtools
#module load picard-tools/1.96
#module load gatk/3.1-1

##add paths to files
HOMEPATH=temp/bwa_gatk/anna_assembly_outbred/align/run1/
MAINPATH=data/raw/
REFPATH=${HOMEPATH}/ref/ALM_F2Male_MDS349_CLCassembly.fasta
BWATEMPPATH=${HOMEPATH}/data/bwa_temp/

picardpath=/data1/jbrown/local_programs/picard/picard.jar
gatkpath=/data1/jbrown/local_programs/gatk/GenomeAnalysisTK.jar
##add array of filenames

PREFIXES=(JBB_hb701_Lcombo
JBB_hb702_Lcombo
JBB_hb703_Lcombo
JBB_hb704_Lcombo
JBB_hb705_Lcombo
JBB_hb706_Lcombo
JBB_hb707_Lcombo
JBB_hb708_Lcombo
JBB_hb709_Lcombo
JBB_hb710_Lcombo
JBB_hb711_Lcombo
JBB_hb712_Lcombo)
PREFIX=shrimp_outbred_ill2
PREFIX=louse_outbred_180_500

##make final ${HOMEPATH}/data path

##  merge/sort bam files	
##java -jar /${HOMEPATH}/data/apps/picard-tools/1.96/MergeSamFiles.jar I=${HOMEPATH}/data/bam/${PREFIXES[0]}.RGbam I=${HOMEPATH}/data/bam/${PREFIXES[1]}.RGbam I=${HOMEPATH}/data/bam/${PREFIXES[2]}.RGbam I=${HOMEPATH}/data/bam/${PREFIXES[3]}.RGbam I=${HOMEPATH}/data/bam/${PREFIXES[4]}.RGbam I=${HOMEPATH}/data/bam/${PREFIXES[5]}.RGbam I=${HOMEPATH}/data/bam/${PREFIXES[6]}.RGbam I=${HOMEPATH}/data/bam/${PREFIXES[7]}.RGbam I=${HOMEPATH}/data/bam/${PREFIXES[8]}.RGbam I=${HOMEPATH}/data/bam/${PREFIXES[9]}.RGbam I=${HOMEPATH}/data/bam/${PREFIXES[10]}.RGbam I=${HOMEPATH}/data/bam/${PREFIXES[11]}.RGbam SO=coordinate AS=true VALIDATION_STRINGENCY=SILENT O=${HOMEPATH}/data/gatk/merged.bam
#java -Xmx128g -Djava.io.tmpdir=${PWD}/tmp -jar $picardpath SortSam I=${HOMEPATH}/data/bam/${PREFIX}.RGbam O=${HOMEPATH}/data/gatk/merged.bam SO=coordinate VALIDATION_STRINGENCY=LENIENT
samtools index ${HOMEPATH}/data/gatk/merged.bam

##  make vcf files
java -d64 -Xmx128g -Djava.io.tmpdir=${PWD}/tmp -jar $gatkpath -T RealignerTargetCreator -nt 16 -R ${REFPATH} -I ${HOMEPATH}/data/gatk/merged.bam --minReadsAtLocus 4 -o ${HOMEPATH}/data/gatk/merged.intervals
java -d64 -Xmx128g -Djava.io.tmpdir=${PWD}/tmp -jar $gatkpath -T IndelRealigner -R ${REFPATH} -I ${HOMEPATH}/data/gatk/merged.bam -targetIntervals ${HOMEPATH}/data/gatk/merged.intervals -LOD 3.0 -o ${HOMEPATH}/data/gatk/merged-realigned.bam
java -d64 -Xmx128g -Djava.io.tmpdir=${PWD}/tmp -jar $gatkpath -T UnifiedGenotyper -nt 16 -R ${REFPATH} -I ${HOMEPATH}/data/gatk/merged-realigned.bam -gt_mode DISCOVERY -stand_call_conf 30 -o ${HOMEPATH}/data/gatk/rawSNPS-Q30.vcf
java -d64 -Xmx128g -Djava.io.tmpdir=${PWD}/tmp -jar $gatkpath -T VariantAnnotator -nt 16 -R ${REFPATH} -I ${HOMEPATH}/data/gatk/merged-realigned.bam -G StandardAnnotation -V:variant,VCF ${HOMEPATH}/data/gatk/rawSNPS-Q30.vcf -XA SnpEff -o ${HOMEPATH}/data/gatk/rawSNPS-Q30-annotated.vcf
java -d64 -Xmx128g -Djava.io.tmpdir=${PWD}/tmp -jar $gatkpath -T UnifiedGenotyper -nt 16 -R ${REFPATH} -I ${HOMEPATH}/data/gatk/merged-realigned.bam -gt_mode DISCOVERY -glm INDEL -stand_call_conf 30 -o ${HOMEPATH}/data/gatk/inDels-Q30.vcf
java -d64 -Xmx128g -Djava.io.tmpdir=${PWD}/tmp -jar $gatkpath -T VariantFiltration -R ${REFPATH} -V ${HOMEPATH}/data/gatk/rawSNPS-Q30-annotated.vcf --mask ${HOMEPATH}/data/gatk/inDels-Q30.vcf --maskExtension 5 --maskName InDel --clusterWindowSize 10 --filterExpression "MQ0 >= 4 && ((MQ0 / (1.0 * DP)) > 0.1)" --filterName "BadValidation" --filterExpression "QUAL < 30.0" --filterName "LowQual" --filterExpression "QD < 5.0" --filterName "LowVQCBD" --filterExpression "FS > 60" --filterName "FisherStrand" -o ${HOMEPATH}/data/gatk/Q30-SNPs.vcf
cat ${HOMEPATH}/data/gatk/Q30-SNPs.vcf | grep 'PASS\|^#' > ${HOMEPATH}/data/gatk/only-PASS-Q30-SNPs.vcf
java -d64 -Xmx128g -Djava.io.tmpdir=${PWD}/tmp -jar $gatkpath -T VariantFiltration -R ${REFPATH} -V ${HOMEPATH}/data/gatk/inDels-Q30.vcf --clusterWindowSize 10 --filterExpression "MQ0 >= 4 && ((MQ0 / (1.0 * DP)) > 0.1)" --filterName "BadValidation" --filterExpression "QUAL < 30.0" --filterName "LowQual" --filterExpression "QD < 5.0" --filterName "LowVQCBD" --filterExpression "FS > 60" --filterName "FisherStrand" -o ${HOMEPATH}/data/gatk/Q30-INDEL.vcf
cat ${HOMEPATH}/data/gatk/Q30-INDEL.vcf | grep 'PASS\|^#' > ${HOMEPATH}/data/gatk/only-PASS-Q30-INDEL.vcf
