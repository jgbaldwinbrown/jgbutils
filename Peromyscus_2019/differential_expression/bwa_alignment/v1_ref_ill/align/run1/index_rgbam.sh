#!/bin/bash
#$ -N INDEXBAM
#$ -q bio,pub64,adl
#$ -pe openmp 1
#$ -R y
#$ -t 1-12
#$ -hold_jid INDEXER
module load enthought_python
module load java/1.7
module load bwa
module load samtools
module load picard-tools/1.96
module load gatk/3.1-1

#identify job number
JOBNUM=`echo "${SGE_TASK_ID}-1" | bc`

#add paths to files
MAINPATH=/dfs1/bio/jbaldwi1/shrimp_data/illumina_data_3_wild_and_rna/bwa_alignment/v1_nondbg2olc/data/raw/
REFPATH=/dfs1/bio/jbaldwi1/shrimp_data/illumina_data_3_wild_and_rna/bwa_alignment/v1_nondbg2olc/ref/shrimp_qmerged.quiver.fasta
BWATEMPPATH=/dfs1/bio/jbaldwi1/shrimp_data/illumina_data_3_wild_and_rna/bwa_alignment/v1_nondbg2olc/data/bwa_temp/

#add array of filenames

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

PREFIX=${PREFIXES[${JOBNUM}]}

#make final data path
FDATAPATH="${MAINPATH}${PREFIX}_R1_001.fastq.gz"
RDATAPATH="${MAINPATH}${PREFIX}_R2_001.fastq.gz"


#####  I could have written this to run much faster by submitting tasks in parallel
#####  but at a price of much less transparent code.  

##  fq -> bam
#bwa aln -t 16  $REFPATH $FDATAPATH > ${BWATEMPPATH}${PREFIX}.F.sai
#bwa aln -t 16  $REFPATH $RDATAPATH > ${BWATEMPPATH}${PREFIX}.R.sai
#bwa sampe ${REFPATH} ${BWATEMPPATH}${PREFIX}.F.sai ${BWATEMPPATH}${PREFIX}.R.sai $FDATAPATH $RDATAPATH        | samtools view -q 20 -bS - | samtools sort - data/bam/$PREFIX


## reorder for gatk happiness
## "VALIDATION_STRINGENCY=LENIENT" necessary due to bwa giving a small number of reads that span concatenated chromosomes (false positives) a non-zero MAPQ score
#java -Xmx2g -jar /data/apps/picard-tools/1.96/ReorderSam.jar INPUT=data/bam/${PREFIX}.bam OUTPUT=data/bam/${PREFIX}.rbam REFERENCE=$REFPATH VALIDATION_STRINGENCY=LENIENT

## index bam
samtools index data/bam/${PREFIX}.RGbam       

##  add readgroup names
#java -Xmx20g -jar /data/apps/picard-tools/1.96/AddOrReplaceReadGroups.jar I=data/bam/${PREFIX}.rbam O=data/bam/${PREFIX}.RGbam SORT_ORDER=coordinate RGPL=illumina RGPU=D109LACXX RGLB=Lib1 RGID=${PREFIX} RGSM=${PREFIX} VALIDATION_STRINGENCY=LENIENT
