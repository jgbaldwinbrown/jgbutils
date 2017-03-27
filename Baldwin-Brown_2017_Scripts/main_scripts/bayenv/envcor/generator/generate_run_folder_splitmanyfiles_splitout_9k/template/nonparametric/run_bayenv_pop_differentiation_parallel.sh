#!/bin/bash
#$ -N baypop_12
#$ -q bio,pub64,abio,free64,free48
#$ -pe openmp 4
###$ -R y
###$ -t 1-2
#$ -t 1-9000
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
snpfile_base_notxt=`basename $SNPFILE .txt | tr -d '\n'`
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
todo_suf=`echo ${j} | python -c 'import sys; sys.stdout.write("%010d" % (int(list(sys.stdin)[0].rstrip("\n")) / 90000,))'`
todo_index=`echo ${j} | python -c 'import sys; sys.stdout.write(str(int(list(sys.stdin)[0].rstrip("\n")) % 90000))'`
todo_to_use=to_do${todo_suf}
i=`head -n ${todo_index} ${todo_to_use} | tail -n 1 | tr -d '\n'`
myoutfile=`echo ${i} | python -c 'import sys; sys.stdout.write("out" + "%010d" % (int(list(sys.stdin)[0].rstrip("\n")) % 1000,))'`
f=`echo s${i}`
snptabsuf=`echo ${i} | python -c 'import sys; sys.stdout.write("%010d" % (int(list(sys.stdin)[0].rstrip("\n")) / 90000,))'`
snpfile_to_use=`echo ${snpfile_base_notxt}${snptabsuf}`
#iend=`echo "${i} * 2" | bc`
iend=`echo ${i} | python -c 'import sys; sys.stdout.write(str(int(list(sys.stdin)[0].rstrip("\n")) % 90000))'`
istart=`echo "${iend} - 1" | bc`
head -n ${iend} ${snpfile_to_use} | tail -n 2 > ${f}
rseeds_suf=`echo ${i} | python -c 'import sys; sys.stdout.write("%010d" % (int(list(sys.stdin)[0].rstrip("\n")) / 90000,))'`
rseeds_to_use=rseeds${rseeds_suf}
rseed_index=`echo ${i} | python -c 'import sys; sys.stdout.write(str(int(list(sys.stdin)[0].rstrip("\n")) % 90000))'`
RSEED=`head -n ${rseed_index} ${rseeds_to_use} | tail -n 1 | tr -d '\n'`
#./bayenv2 -i $f -e $ENVFILE -m $MATFILE -k $ITNUM -r $RANDOM -p $POPNUM -n $ENVNUM -t
./bayenv2 -i $f -m $MATFILE -e $ENVFILE -n $ENVNUM -p $POPNUM -k $ITNUM -t -f -X -c -r $RSEED -o $myoutfile

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
rm core*

done

#rm -f snp_batch*
