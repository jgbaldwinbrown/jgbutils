#!/bin/bash
#$ -N str
#$ -pe openmp 1
#$ -R y
#$ -q bio,pub64,abio,free64,free48
#$ -ckpt restart

module load bedtools
module load python/3.6.1
module unload python/2.7.2

set -e
#cd $SGE_O_WORKDIR

cat listsam.txt | while read line
do
    outpath=`dirname $line`/`basename $line .txt`_11.txt
    cat $line | python3 add_last_to_first.py > $outpath
done

#./haplocaller_200ploid/degs_snpsfile.txt
#./haplocaller_200ploid/full_snpsfile.txt
#./haplocaller_200ploid/degs_snpsfile_cens.txt
#./haplocaller_200ploid/full_snpsfile_cens.txt
#./haplocaller_2ploid/full_snpsfile_cens.txt
#./haplocaller_2ploid/full_snpsfile.txt
#./haplocaller_2ploid/degs_snpsfile.txt
#./haplocaller_2ploid/degs_snpsfile_cens.txt
#./samtools_popoolation/degs_snpsfile.txt
#./samtools_popoolation/degs_snpsfile_cens.txt
#./samtools_popoolation/full_snpsfile.txt
#./samtools_popoolation/full_snpsfile_cens.txt
