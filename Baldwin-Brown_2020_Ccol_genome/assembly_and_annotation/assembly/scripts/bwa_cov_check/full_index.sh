#!/bin/bash
picardpath=/data1/jbrown/local_programs/picard/picard.jar
bwa index $1
samtools faidx $1
java -jar $picardpath CreateSequenceDictionary R=$1 O=${1}.dict
