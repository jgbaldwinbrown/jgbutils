#!/bin/bash
#$ -N INDEXER
#$ -q bio,pub64,adl
#$ -pe openmp 2
#$ -R y
#$ -hold_jid copy
#module load enthought_python
#module load bwa
#module load samtools
#module load picard-tools/1.96

picardpath=/data1/jbrown/local_programs/picard/picard.jar

HOMEPATH=temp/bwa_gatk/anna_assembly_outbred/align/run1/
REFPATH=${HOMEPATH}/ref/ALM_F2Male_MDS349_CLCassembly.fasta

mkdir -p ${HOMEPATH}/ref
rsync -avP raw_data/previous_assemblies/taxon_filtered_louse/ALM_F2Male_MDS349_CLCassembly.fasta $REFPATH

bwa index $REFPATH
samtools faidx $REFPATH
java -jar $picardpath CreateSequenceDictionary R=$REFPATH O=${HOMEPATH}/ref/ALM_F2Male_MDS349_CLCassembly.dict
