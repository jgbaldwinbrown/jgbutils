#!/bin/bash
#$ -N make_all_falcon_fastas
#$ -pe openmp 1
###$ -R Y
#$ -q bio,pub64,som
###$ -ckpt restart
###$ -t 1-60

# Go to the directory from which the job was launched.
cd $SGE_O_WORKDIR

module load dextractor/1.0

myhome=`pwd`
cat cell_list.txt | while read line
do
  rootname=`echo "${line}" | python -c "import sys; sys.stdout.write(sys.stdin.readlines()[0].split()[0])"` && \
  pathname=`echo "${line}" | python -c "import sys; sys.stdout.write(sys.stdin.readlines()[0].split()[1])"` && \
  mkdir ${rootname} && \
  cd ${rootname} && \
  tar -xzvf ${pathname} -C . && \
  mv extra/${rootname}*.bax.h5 . && \
  rm -r extra && \i
  dextract -v -o ${rootname}* && \
  rm ${rootname}*.bax.h5
  cd $myhome
done
