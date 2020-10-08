#/bin/bash
#$ -N SDEDUP
#$ -q bio,adl,pub64
#$ -pe openmp 32-64
#$ -ckpt restart
#$ -hold_jid MERGEBAM

module load picard-tools
module load gatk
module load java/1.7

#old modules:
#module load enthought_python
#module load java/1.7
module load bwa
module load samtools
#module load picard-tools/1.96
#module load gatk/3.1-1

REFPATH=ref/peromyscus_assembly_polished_v1.fasta

#PREFIXES=(JBB_hb701_Lcombo
#JBB_hb702_Lcombo
#JBB_hb703_Lcombo
#JBB_hb704_Lcombo
#JBB_hb705_Lcombo
#JBB_hb706_Lcombo
#JBB_hb707_Lcombo
#JBB_hb708_Lcombo
#JBB_hb709_Lcombo
#JBB_hb710_Lcombo
#JBB_hb711_Lcombo
#JBB_hb712_Lcombo)

PREFIX=inbred_ill

for i in 0
do
    #prefix=${PREFIXES[${i}]}
    prefix=$PREFIX
    samtools view -bhr ${prefix} ../data/gatk/merged-realigned.bam > ${prefix}.bam
    samtools sort ${prefix}.bam -o ${prefix}.sort.bam
    ##samtools view -H ${prefix}.sort.bam | cat - rg3 > ${prefix}header
    ##samtools reheader ${prefix}header ${prefix}.sort.bam > ${prefix}.sort.rehead.bam
    java -jar /data/apps/picard-tools/1.130/picard.jar CleanSam I=${prefix}.sort.bam O=${prefix}.sort.clean.bam
    java -jar /data/apps/picard-tools/1.130/picard.jar MarkDuplicates INPUT=${prefix}.sort.clean.bam OUTPUT=${prefix}.sort.dedup2.bam METRICS_FILE=${prefix}.dedup2.metrics.txt REMOVE_DUPLICATES=true
done

java -jar /data/apps/picard-tools/1.130/picard.jar MergeSamFiles I=${PREFIX}.sort.dedup2.bam SO=coordinate AS=true VALIDATION_STRINGENCY=SILENT O=merged-realigned-deduped2.bam
cp merged-realigned-deduped2.bam ../data/gatk/merged_deduped.bam
#samtools index merged-realigned-deduped2.bam

#to regenerate vcf files:

#java -d64 -Xmx128g -jar /data/apps/gatk/3.1-1/GenomeAnalysisTK.jar -T UnifiedGenotyper -nt ${CORES} -R ${REFPATH} -I merged-realigned-deduped2.bam -gt_mode DISCOVERY -stand_call_conf 30 -stand_emit_conf 10 -o rawSNPS-Q30_v2.vcf
#java -d64 -Xmx128g -jar /data/apps/gatk/3.1-1/GenomeAnalysisTK.jar -T VariantAnnotator -nt ${CORES} -R ${REFPATH} -I merged-realigned-deduped2.bam -G StandardAnnotation -V:variant,VCF rawSNPS-Q30_v2.vcf -XA SnpEff -o rawSNPS-Q30-annotated_v2.vcf
#java -d64 -Xmx128g -jar /data/apps/gatk/3.1-1/GenomeAnalysisTK.jar -T UnifiedGenotyper -nt ${CORES} -R ${REFPATH} -I merged-realigned-deduped2.bam -gt_mode DISCOVERY -glm INDEL -stand_call_conf 30 -stand_emit_conf 10 -o inDels-Q30_v2.vcf
#java -d64 -Xmx20g -jar /data/apps/gatk/3.1-1/GenomeAnalysisTK.jar -T VariantFiltration -R ${REFPATH} -V rawSNPS-Q30-annotated_v2.vcf --mask inDels-Q30_v2.vcf --maskExtension 5 --maskName InDel --clusterWindowSize 10 --filterExpression "MQ0 >= 4 && ((MQ0 / (1.0 * DP)) > 0.1)" --filterName "BadValidation" --filterExpression "QUAL < 30.0" --filterName "LowQual" --filterExpression "QD < 5.0" --filterName "LowVQCBD" --filterExpression "FS > 60" --filterName "FisherStrand" -o Q30-SNPs_v2.vcf
#cat Q30-SNPs_v2.vcf | grep 'PASS\|^#' > only-PASS-Q30-SNPs_v2.vcf
#java -d64 -Xmx20g -jar /data/apps/gatk/3.1-1/GenomeAnalysisTK.jar -T VariantFiltration -R ${REFPATH} -V inDels-Q30_v2.vcf --clusterWindowSize 10 --filterExpression "MQ0 >= 4 && ((MQ0 / (1.0 * DP)) > 0.1)" --filterName "BadValidation" --filterExpression "QUAL < 30.0" --filterName "LowQual" --filterExpression "QD < 5.0" --filterName "LowVQCBD" --filterExpression "FS > 60" --filterName "FisherStrand" -o Q30-INDEL_v2.vcf
#cat Q30-INDEL_v2.vcf | grep 'PASS\|^#' > only-PASS-Q30-INDEL_v2.vcf

#to generate snp files:

#perl snptable.pl 12 7 <only-PASS-Q30-SNPs_v2.vcf >only-PASS-Q30-SNPs-cov_v2.txt
#perl snptable.pl 12 7 <only-PASS-Q30-INDEL_v2.vcf >only-PASS-Q30-INDEL-cov_v2.txt
