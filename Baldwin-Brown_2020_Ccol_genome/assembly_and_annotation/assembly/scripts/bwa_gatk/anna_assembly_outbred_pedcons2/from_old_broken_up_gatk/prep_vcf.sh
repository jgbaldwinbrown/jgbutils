#!/bin/bash
#$ -N PREPVCF
#$ -q bio,pub64,adl
#$ -pe openmp 16
#$ -R y
#$ -hold_jid INDEXER
#module load enthought_python
#module load java/1.7
#module load bwa
#module load samtools
#module load picard-tools/1.96
#module load gatk/3.1-1

#identify job number

#add paths to files
HOMEPATH=temp/bwa_gatk/anna_assembly_outbred/align/run1/
MAINPATH=data/raw/
REFPATH=${HOMEPATH}/ref/ALM_F2Male_MDS349_CLCassembly.fasta
BWATEMPPATH=${HOMEPATH}/data/bwa_temp/

picardpath=/data1/jbrown/local_programs/picard/picard.jar
gatkpath=/data1/jbrown/local_programs/gatk/GenomeAnalysisTK.jar
#add array of filenames

PREFIX=louse_outbred_180_500
#PREFIX=${PREFIXES[${JOBNUM}]}

#make necessary dirs:
mkdir -p ${HOMEPATH}/fdata_full ${HOMEPATH}/data/bwa_temp ${HOMEPATH}/data/bam ${HOMEPATH}/data/gatk ${HOMEPATH}/data/snptables

#make final data path
FDATAPATH=${HOMEPATH}/fdata_full/fdata.fq
RDATAPATH=${HOMEPATH}/fdata_full/rdata.fq

#  fq -> bam
###bwa sampe ${REFPATH} ${BWATEMPPATH}${PREFIX}.F.sai $FDATAPATH | samtools view -q 20 -bS - | samtools sort - -o data/bam/${PREFIX}.dbam
#bwa sampe ${REFPATH} ${BWATEMPPATH}${PREFIX}.F.sai ${BWATEMPPATH}${PREFIX}.R.sai $FDATAPATH $RDATAPATH | samtools view -q 20 -bS - | samtools sort - ${HOMEPATH}/data/bam/${PREFIX}.dbam

#java -Xmx100g -jar $picardpath CleanSam I=${HOMEPATH}/data/bam/${PREFIX}.dbam.bam O=${HOMEPATH}/data/bam/${PREFIX}.bam

# reorder for gatk happiness
# "VALIDATION_STRINGENCY=LENIENT" necessary due to bwa giving a small number of reads that span concatenated chromosomes (false positives) a non-zero MAPQ score
java -Xmx100g -jar $picardpath ReorderSam INPUT=${HOMEPATH}data/bam/${PREFIX}.bam OUTPUT=${HOMEPATH}/data/bam/${PREFIX}.rbam REFERENCE=$REFPATH VALIDATION_STRINGENCY=LENIENT

# index bam
samtools index ${HOMEPATH}/data/bam/${PREFIX}.rbam       

#  add readgroup names
java -Xmx100g -jar $picardpath AddOrReplaceReadGroups I=${HOMEPATH}/data/bam/${PREFIX}.rbam O=${HOMEPATH}/data/bam/${PREFIX}.RGbam SORT_ORDER=coordinate RGPL=illumina RGPU=D109LACXX RGLB=Lib1 RGID=${PREFIX} RGSM=${PREFIX} VALIDATION_STRINGENCY=LENIENT

####temporary, to remove:
#module load picard-tools/1.130
#java -Xmx8g -jar /data/apps/picard-tools/1.130/picard.jar CleanSam I=data/bam/shrimp_outbred_ill2.dRGbam O=data/bam/shrimp_outbred_ill2.RGbam
