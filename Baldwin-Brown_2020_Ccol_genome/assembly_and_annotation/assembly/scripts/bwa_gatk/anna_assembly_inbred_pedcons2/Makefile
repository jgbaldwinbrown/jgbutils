SHELL := /bin/bash

all: data/snp_tables/only-PASS-Q30-SNPs.txt data/snp_tables/only-PASS-Q30-INDEL.txt

.PHONY:

.DELETE_ON_ERROR:

infiles_forward = /data1/mshapiro/data/columbicola/180bp_library/duplicates_removed/columbicola_180_seqyclean_PE1.fastq.gz
infiles_reverse = /data1/mshapiro/data/columbicola/180bp_library/duplicates_removed/columbicola_180_seqyclean_PE2.fastq.gz
ref = /data1/jbrown/louse_project/temp/megan/anna_assembly_to_nr_R1-ex.fasta
REFPATH = data/ref/ref.fa
HOMEPATH = ./
MAINPATH = data/raw
BWATEMPPATH = data/bwa_temp
picardpath = /data1/jbrown/local_programs/picard/picard.jar
gatkpath = /data1/jbrown/local_programs/gatk/GenomeAnalysisTK.jar
PREFIX = all_out
FDATAPATH=${HOMEPATH}/fdata_full/fdata.fq
RDATAPATH=${HOMEPATH}/fdata_full/rdata.fq

#dirs_made.txt:
#	mkdir -p ${HOMEPATH}/fdata_full ${HOMEPATH}/data/bwa_temp ${HOMEPATH}/data/bam ${HOMEPATH}/data/gatk ${HOMEPATH}/data/snptables

#copy all data

fdata_full/fdata.fq:
	mkdir -p `dirname $@`
	gunzip -c ${infiles_forward} > $@
fdata_full/rdata.fq:
	mkdir -p `dirname $@`
	gunzip -c ${infiles_reverse} > $@

#copy and index reference:

data/ref/ref.fa:
	mkdir -p ${HOMEPATH}/data/ref
	rsync -avP ${ref} ${REFPATH}

indexed.txt: data/ref/ref.fa
	bwa index ${REFPATH}
	samtools faidx ${REFPATH}
	java -jar ${picardpath} CreateSequenceDictionary R=${REFPATH} O=${HOMEPATH}/data/ref/ref.dict
	touch $@

#align with BWA and clean up bam:

data/bam/all_out.dbam: indexed.txt fdata_full/fdata.fq fdata_full/rdata.fq
	mkdir -p `dirname $@`
	bwa mem -t 16 -r '@rg\tid:outbred_reads\tsm:louse_ref\tlb:outbred_pe_ill' ${REFPATH} ${FDATAPATH} ${RDATAPATH} | samtools view -q 20 -bS - > $@
data/bam/all_out.fbam: data/bam/all_out.dbam
	samtools fixmate -O bam $< $@
data/bam/all_out.sbam: data/bam/all_out.fbam
	mkdir -p tmp
	samtools sort -O bam -o $@ -T tmp/sortbam $<
data/bam/all_out_bamsum.txt: data/bam/all_out.sbam
	samtools flagstat $< > $@
	touch $@
data/bam/all_out.bam: data/bam/all_out.sbam
	java -Xmx100g -Djava.io.tmpdir=${PWD}/tmp -jar ${picardpath} CleanSam I=${HOMEPATH}/data/bam/${PREFIX}.sbam O=${HOMEPATH}/data/bam/${PREFIX}.bam
data/bam/all_out.rbam: data/bam/all_out.bam
	java -Xmx100g -Djava.io.tmpdir=${PWD}/tmp -jar ${picardpath} ReorderSam INPUT=${HOMEPATH}data/bam/${PREFIX}.bam OUTPUT=${HOMEPATH}/data/bam/${PREFIX}.rbam REFERENCE=${REFPATH} VALIDATION_STRINGENCY=LENIENT
data/bam/indexed_rbam.txt: data/bam/all_out.rbam
	samtools index ${HOMEPATH}/data/bam/${PREFIX}.rbam
	touch $@
data/bam/all_out.RGbam: data/bam/all_out.rbam
	java -Xmx100g -jar ${picardpath} AddOrReplaceReadGroups I=${HOMEPATH}/data/bam/${PREFIX}.rbam O=${HOMEPATH}/data/bam/${PREFIX}.RGbam SORT_ORDER=coordinate RGPL=illumina RGPU=D109LACXX RGLB=Lib1 RGID=${PREFIX} RGSM=${PREFIX} VALIDATION_STRINGENCY=LENIENT
data/gatk/merged.bam: data/bam/all_out.RGbam
	mkdir -p `dirname $@`
	cp $< $@
data/gatk/indexed_merged.txt: data/gatk/merged.bam
	samtools index $<
	touch $@

#make VCF file:

data/gatk/merged.intervals: data/gatk/indexed_merged.txt
	java -d64 -Xmx128g -Djava.io.tmpdir=${PWD}/tmp -jar ${gatkpath} -T RealignerTargetCreator -nt 16 -R ${REFPATH} -I ${HOMEPATH}/data/gatk/merged.bam --minReadsAtLocus 4 -o ${HOMEPATH}/data/gatk/merged.intervals
data/gatk/merged-realigned.bam: data/gatk/merged.intervals
	java -d64 -Xmx128g -Djava.io.tmpdir=${PWD}/tmp -jar ${gatkpath} -T IndelRealigner -R ${REFPATH} -I ${HOMEPATH}/data/gatk/merged.bam -targetIntervals ${HOMEPATH}/data/gatk/merged.intervals -LOD 3.0 -o ${HOMEPATH}/data/gatk/merged-realigned.bam
data/gatk/rawSNPs-Q30.vcf: data/gatk/merged-realigned.bam
	java -d64 -Xmx128g -Djava.io.tmpdir=${PWD}/tmp -jar ${gatkpath} -T UnifiedGenotyper -nt 16 -R ${REFPATH} -I ${HOMEPATH}/data/gatk/merged-realigned.bam -gt_mode DISCOVERY -stand_call_conf 30 -o ${HOMEPATH}/data/gatk/rawSNPs-Q30.vcf
data/gatk/rawSNPs-Q30-annotated.vcf: data/gatk/rawSNPs-Q30.vcf
	java -d64 -Xmx128g -Djava.io.tmpdir=${PWD}/tmp -jar ${gatkpath} -T VariantAnnotator -nt 16 -R ${REFPATH} -I ${HOMEPATH}/data/gatk/merged-realigned.bam -G StandardAnnotation -V:variant,VCF ${HOMEPATH}/data/gatk/rawSNPs-Q30.vcf -XA SnpEff -o ${HOMEPATH}/data/gatk/rawSNPs-Q30-annotated.vcf
data/gatk/inDels-Q30.vcf: data/gatk/merged-realigned.bam
	java -d64 -Xmx128g -Djava.io.tmpdir=${PWD}/tmp -jar ${gatkpath} -T UnifiedGenotyper -nt 16 -R ${REFPATH} -I ${HOMEPATH}/data/gatk/merged-realigned.bam -gt_mode DISCOVERY -glm INDEL -stand_call_conf 30 -o ${HOMEPATH}/data/gatk/inDels-Q30.vcf
data/gatk/Q30-SNPs.vcf: data/gatk/rawSNPs-Q30-annotated.vcf data/gatk/inDels-Q30.vcf
	java -d64 -Xmx128g -Djava.io.tmpdir=${PWD}/tmp -jar ${gatkpath} -T VariantFiltration -R ${REFPATH} -V ${HOMEPATH}/data/gatk/rawSNPs-Q30-annotated.vcf --mask ${HOMEPATH}/data/gatk/inDels-Q30.vcf --maskExtension 5 --maskName InDel --clusterWindowSize 10 --filterExpression "MQ0 >= 4.0 && ((MQ0 / (1.0 * DP)) > 0.1)" --filterName "BadValidation" --filterExpression "QUAL < 30.0" --filterName "LowQual" --filterExpression "QD < 5.0" --filterName "LowVQCBD" --filterExpression "FS > 60.0" --filterName "FisherStrand" -o ${HOMEPATH}/data/gatk/Q30-SNPs.vcf
data/gatk/only-PASS-Q30-SNPs.vcf: data/gatk/Q30-SNPs.vcf
	cat ${HOMEPATH}/data/gatk/Q30-SNPs.vcf | grep 'PASS\|^#' > ${HOMEPATH}/data/gatk/only-PASS-Q30-SNPs.vcf
data/gatk/Q30-INDEL.vcf: data/gatk/inDels-Q30.vcf
	java -d64 -Xmx128g -Djava.io.tmpdir=${PWD}/tmp -jar ${gatkpath} -T VariantFiltration -R ${REFPATH} -V ${HOMEPATH}/data/gatk/inDels-Q30.vcf --clusterWindowSize 10 --filterExpression "MQ0 >= 4.0 && ((MQ0 / (1.0 * DP)) > 0.1)" --filterName "BadValidation" --filterExpression "QUAL < 30.0" --filterName "LowQual" --filterExpression "QD < 5.0" --filterName "LowVQCBD" --filterExpression "FS > 60.0" --filterName "FisherStrand" -o ${HOMEPATH}/data/gatk/Q30-INDEL.vcf
data/gatk/only-PASS-Q30-INDEL.vcf: data/gatk/Q30-INDEL.vcf
	cat ${HOMEPATH}/data/gatk/Q30-INDEL.vcf | grep 'PASS\|^#' > ${HOMEPATH}/data/gatk/only-PASS-Q30-INDEL.vcf 

#make snptable:
data/snp_tables/only-PASS-Q30-SNPs.txt: data/gatk/only-PASS-Q30-SNPs.vcf snptable_8sigfig.pl
	mkdir -p data/snp_tables
	perl snptable_8sigfig.pl 1 1 <${HOMEPATH}/data/gatk/only-PASS-Q30-SNPs.vcf >${HOMEPATH}/data/snp_tables/only-PASS-Q30-SNPs.txt
data/snp_tables/only-PASS-Q30-INDEL.txt: data/gatk/only-PASS-Q30-INDEL.vcf snptable_8sigfig.pl
	mkdir -p data/snp_tables
	perl snptable_8sigfig.pl 1 1 <${HOMEPATH}/data/gatk/only-PASS-Q30-INDEL.vcf >${HOMEPATH}/data/snp_tables/only-PASS-Q30-INDEL.txt



