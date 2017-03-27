#!/bin/bash
#$ -N baypop_12
#$ -q bio,pub64,abio,free64,free48
#$ -pe openmp 4
###$ -R y
###$ -t 1-2
#$ -t 1-2000
#$ -hold_jid baymat_MYNUMPOPS_MYBEMETHOD
#$ -ckpt restart


#just a small bash script to calculate BFs for all SNPs from SNPFILE
#please copy this script into the same directory as bayenv and execute it there
#please see the Bayenv2 manual for details about usage
#make this script executable (chmod +x calc_bf.sh)
#Usage: ./calc_bf.sh <Name of your SNPSFILE> <Name of your ENVFILE> <Name of your MATFILE> <Nuber of populations> <Number of MCMC iterations> <Number of environmental factors>

#SNPFILE=$1
#ENVFILE=$2
#MATFILE=$3
#POPNUM=$4
#ITNUM=$5
#ENVNUM=$6

#have 2046 runs per job


endpos=`echo "${SGE_TASK_ID} * MYCHUNKSIZE" | bc`
startpos=`echo "${endpos} - (MYCHUNKSIZE - 1)" | bc`



SNPFILE=MYSNPFILE
ENVFILE=MYENVFILE
MATFILE=MYMATFILE
POPNUM=MYNUMPOPS
ITNUM=100000
numenvs=`wc -l MYENVFILE | python -c 'import sys ; [sys.stdout.write(line.split()[0]) for line in sys.stdin]'`
ENVNUM=$numenvs
#RSEED=144403

#split -d -a 10 -l 2 $SNPFILE snp_batch_

for j in $(seq ${startpos} ${endpos})
do
#f is the name of the temporary file used for this run, and the name that will be printed on the final line.
i=`head -n ${j} to_do.txt | tail -n 1 | tr -d '\n'`
f=`echo s${i}`
iend=`echo "${i} * 2" | bc`
istart=`echo "${iend} - 1" | bc`
head -n ${iend} ${SNPFILE} | tail -n 2 > ${f}
RSEED=`head -n ${i} rseeds.txt | tail -n 1 | tr -d '\n'`
#./bayenv2 -i $f -e $ENVFILE -m $MATFILE -k $ITNUM -r $RANDOM -p $POPNUM -n $ENVNUM -t
./bayenv2 -i $f -m $MATFILE -e $ENVFILE -n $ENVNUM -p $POPNUM -k $ITNUM -t -X -r $RSEED

#debug: 
echo i=${i}
echo f=${f}
echo iend=${iend}
echo istart=${istart}
echo rseed=${RSEED}
echo matfile=${MATFILE}
echo envfile=${ENVFILE}
echo envnum=${ENVNUM}
echo popnum=${POPNUM}
echo itnum=${ITNUM}
echo snpsfile=${SNPFILE}
echo snpfile=${f}
echo snpfile_contents:
cat ${f}
cat ${f}.freqs

rm ${f}
rm ${f}.freqs

done

#rm -f snp_batch*
