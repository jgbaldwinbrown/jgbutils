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
HOMEPATH=temp/bwa_gatk/anna_assembly_inbred/align/run1/
MAINPATH=data/raw/
REFPATH=${HOMEPATH}/ref/ALM_F2Male_MDS349_CLCassembly.fasta
BWATEMPPATH=${HOMEPATH}/data/bwa_temp/

picardpath=/data1/jbrown/local_programs/picard/picard.jar
gatkpath=/data1/jbrown/local_programs/gatk/GenomeAnalysisTK.jar
#add array of filenames

PREFIX=louse_inbred_180_500
#PREFIX=${PREFIXES[${JOBNUM}]}

#make necessary directories for all files:
mkdir -p ${HOMEPATH}/fdata_full ${HOMEPATH}/data/bwa_temp ${HOMEPATH}/data/bam ${HOMEPATH}/data/gatk ${HOMEPATH}/data/snptables

#make final data path
FDATAPATH=${HOMEPATH}/fdata_full/fdata.fq
cat scripts/bwa_gatk/anna_assembly_inbred/align/run1/fdatapaths.txt | xargs cat > $FDATAPATH
RDATAPATH=${HOMEPATH}/fdata_full/rdata.fq
cat scripts/bwa_gatk/anna_assembly_inbred/align/run1/rdatapaths.txt | xargs cat > $RDATAPATH

#  fq -> bam
bwa aln -t 16  $REFPATH $FDATAPATH > ${BWATEMPPATH}${PREFIX}.F.sai
bwa aln -t 16  $REFPATH $RDATAPATH > ${BWATEMPPATH}${PREFIX}.R.sai
