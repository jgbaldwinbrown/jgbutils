#!/bin/bash
#$ -N ill2join
#$ -pe openmp 1
#$ -R y
#$ -q bio,abio
#$ -t 1-11
cd $SGE_O_WORKDIR

# module load openmpi-gcc/1.4.4

#PATH=$PATH\:/gl/bio/jbaldwi1/programs/ea-utils/ea-utils.1.1.2-537 ; export PATH

module load ea-utils/06-03-2015

paths=180bp_paths.txt

in1num=`echo "${SGE_TASK_ID}*2-1" | bc`
in2num=`echo "${SGE_TASK_ID}*2" | bc`

in1=`head -n ${in1num} ${paths} | tail -1`
in2=`head -n ${in2num} ${paths} | tail -1`

inprefix="../../../data/gDNA/"

in1f=`echo ${inprefix}${in1}`
in2f=`echo ${inprefix}${in2}`

outdir=/bio/jbaldwi1/tiger_shrimp_data/data/fastqjoin_out/run1_noclip
outprefix=`basename ${in1f} .fastq.gz`

fastq-join ${in1f} ${in2f} -o ${outdir}/${outprefix}.%.fq 1> fqjoin_tigershrimp_out.txt 2> fqjoin_tigershimp_err.txt
