#!/bin/bash
#$ -N make_all_falcon_fastas
#$ -pe openmp 1
###$ -R Y
#$ -q bio,pub64,som
###$ -ckpt restart
###$ -t 1-60

# Go to the directory from which the job was launched.
cd $SGE_O_WORKDIR

#module load dextractor/1.0

#this code accepts either the first argument or the stdin as the input (like python fileinput())
[ $# -ge 1 -a -f "$1" ] && input="$1" || input="-"
#cat $input

myhome=`pwd`
cat $input | while read line
do
  libname=`echo "${line}" | python -c "import sys; sys.stdout.write(sys.stdin.readlines()[0].split()[0])"` && \
  libtarpath=`echo "${line}" | python -c "import sys; sys.stdout.write(sys.stdin.readlines()[0].split()[1])"` && \
  echo $libname
  echo $libtarpath
  mkdir -p baxdata/${libname} && \
  cd baxdata/${libname} && \
  #tar -xzvf ${libtarpath} -C . && \
  tar -xzvf ${libtarpath} -C . --wildcards --no-anchored '*.bax.h5' && \
  mv extra/${libname}*.bax.h5 . && \
  rm -r extra && \
  find $PWD -type f -name '*.bax.h5' | sort > ${libname}_fofn.fofn
  #dextract -v -o ${rootname}* && \
  #rm ${rootname}*.bax.h5
  cd $myhome
done
