#!/bin/bash
#$ -N MERGEBAM
#$ -q bio,pub64,adl
#$ -pe openmp 16
#$ -R y
#$ -hold_jid PREPVCF
module load enthought_python
module load java/1.7
module load bwa
module load samtools
module load picard-tools/1.96
module load gatk/3.1-1

##add paths to files
MAINPATH=data/raw/
REFPATH=ref/peromyscus_assembly_polished_v1.fasta
BWATEMPPATH=data/bwa_temp/

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
PREFIX=inbred_ill

##make final data path

##  merge/sort bam files	
#java -jar /data/apps/picard-tools/1.96/MergeSamFiles.jar I=data/bam/${PREFIXES[0]}.RGbam I=data/bam/${PREFIXES[1]}.RGbam I=data/bam/${PREFIXES[2]}.RGbam I=data/bam/${PREFIXES[3]}.RGbam I=data/bam/${PREFIXES[4]}.RGbam I=data/bam/${PREFIXES[5]}.RGbam I=data/bam/${PREFIXES[6]}.RGbam I=data/bam/${PREFIXES[7]}.RGbam I=data/bam/${PREFIXES[8]}.RGbam I=data/bam/${PREFIXES[9]}.RGbam I=data/bam/${PREFIXES[10]}.RGbam I=data/bam/${PREFIXES[11]}.RGbam SO=coordinate AS=true VALIDATION_STRINGENCY=SILENT O=data/gatk/merged.bam
java -jar /data/apps/picard-tools/1.96/SortSam.jar I=data/bam/${PREFIX} O=data/gatk/merged.bam SO=coordinate
samtools index data/gatk/merged.bam

##  make vcf files
java -d64 -Xmx128g -jar /data/apps/gatk/3.1-1/GenomeAnalysisTK.jar -T RealignerTargetCreator -nt 16 -R ${REFPATH} -I data/gatk/merged.bam --minReadsAtLocus 4 -o data/gatk/merged.intervals
java -d64 -Xmx20g -jar /data/apps/gatk/3.1-1/GenomeAnalysisTK.jar -T IndelRealigner -R ${REFPATH} -I data/gatk/merged.bam -targetIntervals data/gatk/merged.intervals -LOD 3.0 -o data/gatk/merged-realigned.bam
#java -d64 -Xmx128g -jar /data/apps/gatk/3.1-1/GenomeAnalysisTK.jar -T UnifiedGenotyper -nt 16 -R ${REFPATH} -I data/gatk/merged-realigned.bam -gt_mode DISCOVERY -stand_call_conf 30 -stand_emit_conf 10 -o data/gatk/rawSNPS-Q30.vcf
#java -d64 -Xmx128g -jar /data/apps/gatk/3.1-1/GenomeAnalysisTK.jar -T VariantAnnotator -nt 16 -R ${REFPATH} -I data/gatk/merged-realigned.bam -G StandardAnnotation -V:variant,VCF data/gatk/rawSNPS-Q30.vcf -XA SnpEff -o data/gatk/rawSNPS-Q30-annotated.vcf
#java -d64 -Xmx128g -jar /data/apps/gatk/3.1-1/GenomeAnalysisTK.jar -T UnifiedGenotyper -nt 16 -R ${REFPATH} -I data/gatk/merged-realigned.bam -gt_mode DISCOVERY -glm INDEL -stand_call_conf 30 -stand_emit_conf 10 -o data/gatk/inDels-Q30.vcf
#java -d64 -Xmx20g -jar /data/apps/gatk/3.1-1/GenomeAnalysisTK.jar -T VariantFiltration -R ${REFPATH} -V data/gatk/rawSNPS-Q30-annotated.vcf --mask data/gatk/inDels-Q30.vcf --maskExtension 5 --maskName InDel --clusterWindowSize 10 --filterExpression "MQ0 >= 4 && ((MQ0 / (1.0 * DP)) > 0.1)" --filterName "BadValidation" --filterExpression "QUAL < 30.0" --filterName "LowQual" --filterExpression "QD < 5.0" --filterName "LowVQCBD" --filterExpression "FS > 60" --filterName "FisherStrand" -o data/gatk/Q30-SNPs.vcf
#cat data/gatk/Q30-SNPs.vcf | grep 'PASS\|^#' > data/gatk/only-PASS-Q30-SNPs.vcf
#java -d64 -Xmx20g -jar /data/apps/gatk/3.1-1/GenomeAnalysisTK.jar -T VariantFiltration -R ${REFPATH} -V data/gatk/inDels-Q30.vcf --clusterWindowSize 10 --filterExpression "MQ0 >= 4 && ((MQ0 / (1.0 * DP)) > 0.1)" --filterName "BadValidation" --filterExpression "QUAL < 30.0" --filterName "LowQual" --filterExpression "QD < 5.0" --filterName "LowVQCBD" --filterExpression "FS > 60" --filterName "FisherStrand" -o data/gatk/Q30-INDEL.vcf
#cat data/gatk/Q30-INDEL.vcf | grep 'PASS\|^#' > data/gatk/only-PASS-Q30-INDEL.vcf
