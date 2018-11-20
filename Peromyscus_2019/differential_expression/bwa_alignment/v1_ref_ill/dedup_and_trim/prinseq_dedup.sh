#!/bin/bash
#$ -N prinseq
#$ -q bio,abio,free64,pub64,adl
#$ -ckpt restart
#$ -t 1-4

jobnum=$SGE_TASK_ID

module load prinseq-lite

inpaths=inpaths2.txt

freadi=`echo "${jobnum} * 2 - 1" | bc | tr -d '\n'`
rreadi=`echo "${jobnum} * 2" | bc | tr -d '\n'`
fread=`head -n $freadi $inpaths | tail -n 1`
rread=`head -n $rreadi $inpaths | tail -n 1`

freadop=`echo $(basename $fread .gz)`
freadop2=`cut -d '.' -f 1 <(echo $freadop)`
rreadop=`echo $(basename $rread .gz)`
rreadop2=`cut -d '.' -f 1 <(echo $rreadop)`

echo $freadop
echo $rreadop
echo $freadop2
echo $rreadop2


zcat $fread > $freadop
zcat $rread > $rreadop

prinseq-lite.pl -fastq $freadop -fastq2 $rreadop -derep 14

rm $freadop
rm $rreadop

find . -maxdepth 1 -type f | grep $freadop2 | grep -vE '\.gz$' | xargs gzip
find . -maxdepth 1 -type f | grep $rreadop2 | grep -vE '\.gz$' | xargs gzip

