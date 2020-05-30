#!/bin/bash
set -e

cat indices_mini.txt | while read i
do
    DIR=`dirname $i`
    python3 censbed_from_index.py ${DIR}/degs.input.bedified.bed $i > ${DIR}/censbed.bed
done

#python3 censbed_from_index.py haplocaller_2ploid/degs.input.bedified.bed haplocaller_2ploid/full_snpsfile_cens_index.txt
#./haplocaller_200ploid/degs_snpsfile_cens_index.txt
#./haplocaller_200ploid/full_snpsfile_cens_index.txt
#./haplocaller_2ploid/full_snpsfile_cens_index.txt
#./haplocaller_2ploid/degs_snpsfile_cens_index.txt
#./old_correct/full_snpsfile_cens_index.txt
#./old_correct/degs_snpsfile_cens_index.txt
#./samtools_popoolation/full_snpsfile_cens_index.txt
#./samtools_popoolation/degs_snpsfile_cens_index.txt
