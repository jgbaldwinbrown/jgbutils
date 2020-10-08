#!/bin/bash
#$ -N ill2join
#$ -pe openmp 1
#$ -R y
#$ -q bio,abio
#$ -t 1-11
#cd $SGE_O_WORKDIR

# module load openmpi-gcc/1.4.4

#PATH=$PATH\:/gl/bio/jbaldwi1/programs/ea-utils/ea-utils.1.1.2-537 ; export PATH

#module load ea-utils/06-03-2015

paths=scripts/fqjoin/to_fqjoin_unfiltered.txt

jobnum=$1

in1num=`echo "${jobnum}*2-1" | bc`
in2num=`echo "${jobnum}*2" | bc`

in1f=`head -n ${in1num} ${paths} | tail -1`
in2f=`head -n ${in2num} ${paths} | tail -1`

#inprefix="../../../data/gDNA/"

#in1f=`echo ${inprefix}${in1}`
#in2f=`echo ${inprefix}${in2}`

outdir=temp/fqjoin
mkdir -p outdir
outprefix=`basename ${in1f} .txt.gz`

fastq-join ${in1f} ${in2f} -o ${outdir}/${outprefix}.%.fq 1> ${outdir}/fqjoin_unfiltered_out.txt 2> ${outdir}fqjoin_unfiltered_err.txt
