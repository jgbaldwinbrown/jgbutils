#!/bin/bash
#$ -N PREPVCF
#$ -q bio,pub64,adl
#$ -pe openmp 16
#$ -R y
#$ -hold_jid INDEXER
module load enthought_python
module load java/1.7
module load bwa
module load samtools
#module load picard-tools/1.96
module load gatk/3.1-1

#identify job number
JOBNUM=`echo "${SGE_TASK_ID}-1" | bc`

#add paths to files
MAINPATH=data/raw/
REFPATH=ref/peromyscus_assembly_polished_v1.fasta
BWATEMPPATH=data/bwa_temp/

#add array of filenames

PREFIX=shrimp_inbred_ill2
#PREFIX=${PREFIXES[${JOBNUM}]}

#make final data path
FDATAPATH="${MAINPATH}${PREFIX}_clipped_R1.fq.gz"
RDATAPATH="${MAINPATH}${PREFIX}_clipped_R2.fq.gz"


#####  I could have written this to run much faster by submitting tasks in parallel
#####  but at a price of much less transparent code.  

#  fq -> bam
bwa aln -t 16  $REFPATH $FDATAPATH > ${BWATEMPPATH}${PREFIX}.F.sai
bwa aln -t 16  $REFPATH $RDATAPATH > ${BWATEMPPATH}${PREFIX}.R.sai
bwa sampe ${REFPATH} ${BWATEMPPATH}${PREFIX}.F.sai ${BWATEMPPATH}${PREFIX}.R.sai $FDATAPATH $RDATAPATH  | samtools view -q 20 -bS - | samtools sort - -o data/bam/${PREFIX}.dbam

java -Xmx100g -jar /data/apps/picard-tools/1.96/CleanSam.jar I=data/bam/${PREFIX}.dbam O=data/bam/${PREFIX}.bam

# reorder for gatk happiness
# "VALIDATION_STRINGENCY=LENIENT" necessary due to bwa giving a small number of reads that span concatenated chromosomes (false positives) a non-zero MAPQ score
java -Xmx2g -jar /data/apps/picard-tools/1.96/ReorderSam.jar INPUT=data/bam/${PREFIX}.bam OUTPUT=data/bam/${PREFIX}.rbam REFERENCE=$REFPATH VALIDATION_STRINGENCY=LENIENT

# index bam
samtools index data/bam/${PREFIX}.rbam       

#  add readgroup names
java -Xmx20g -jar /data/apps/picard-tools/1.96/AddOrReplaceReadGroups.jar I=data/bam/${PREFIX}.rbam O=data/bam/${PREFIX}.RGbam SORT_ORDER=coordinate RGPL=illumina RGPU=D109LACXX RGLB=Lib1 RGID=${PREFIX} RGSM=${PREFIX} VALIDATION_STRINGENCY=LENIENT

####temporary, to remove:
#module load picard-tools/1.130
#java -Xmx8g -jar /data/apps/picard-tools/1.130/picard.jar CleanSam I=data/bam/shrimp_inbred_ill2.dRGbam O=data/bam/shrimp_inbred_ill2.RGbam
