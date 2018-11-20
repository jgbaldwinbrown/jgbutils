#!/bin/bash
#$ -N prinseq
#$ -q bio,abio,free64,pub64
#$ -ckpt restart
#$ -t 1-9

jobnum=$SGE_TASK_ID

module load prinseq-lite

freadi=`echo "${jobnum} * 2 - 1" | bc | tr -d '\n'`
rreadi=`echo "${jobnum} * 2" | bc | tr -d '\n'`
fread=`head -n $freadi rnaseq_paths_sorted.txt | tail -n 1`
rread=`head -n $rreadi rnaseq_paths_sorted.txt | tail -n 1`

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

