#!/bin/bash
#$ -N gage_pilon_JOBNUM
#$ -pe openmp 1
#$ -R N
#$ -q bio,pub64,pub8i
###$ -t 1-22
###$ -ckpt restart
###$ -hold_jid pilon_JOBNUM

# Go to the directory from which the job was launched.
cd $SGE_O_WORKDIR

export PATH=/bio/jbaldwi1/dbg2olc/mel/gage_validation/new_version:$PATH
module load MUMmer
module load perl
module load java

#job=$SGE_TASK_ID

# Go to the directory from which the job was launched.
cd $SGE_O_WORKDIR

rsync -avP ../infasta.fasta .

getCorrectnessStats.sh /dfs1/bio/jbaldwi1/dbg2olc/mel/reference/dmel-all-chromosome-r6.01.fasta infasta.fasta infasta.fasta 1> gage_out.txt 2> gage_err.txt



#python run_gage_assessment.py files_to_assess_outpaths3.txt files_to_assess.txt /bio/jbaldwi1/dbg2olc/mel/reference/dmel-all-chromosome-r6.01.fasta $job
#
#import sys
#import subprocess
#import os
#
#outpaths = sys.argv[1]
#inpaths = sys.argv[2]
#refpath = sys.argv[3]
#jobnum = int(sys.argv[4])
#mycwd = os.getcwd()
#
#outpathlist = [line.rstrip('\n') for line in open(outpaths,"r")]
#inpathlist = [line.rstrip('\n') for line in open(inpaths,"r")]
#
#myoutpath = outpathlist[jobnum-1]
##mystdoutpath = myoutpath + "/gage_out.txt"
##mystderrpath = myoutpath + "/gage_err.txt"
#mystdoutpath = "gage_out.txt"
#mystderrpath = "gage_err.txt"
#myinpath = inpathlist[jobnum-1]
#
#os.chdir(myoutpath)
#
#subprocess.call(['getCorrectnessStats.sh',refpath,myinpath,myinpath],stdout=mystdoutpath,stderr=mystderrpath)
#os.chdir(mycwd)
