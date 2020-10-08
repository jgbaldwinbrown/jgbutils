#!/bin/bash
#$ -N jelly_pero
#$ -pe openmp 64
#$ -R Y
#$ -q bio,pub64,adl

# Go to the directory from which the job was launched.
#cd $SGE_O_WORKDIR

#module load jellyfish

a=`find temp/fqjoin -name '*.fq' | sort`

jellyfish count -m 15 -s 3000M -t 16 -o temp/jellyfish/louse_ill_joined_15mer_counts.jf -C $(echo $a) 1> temp/jellyfish/jellyfish_count_out15.txt 2> temp/jellyfish/jellyfish_count_err15.txt
#66 threads, 3 billion hash elements, 15mers.

jellyfish histo temp/jellyfish/louse_ill_joined_15mer_counts.jf  1> temp/jellyfish/louse_ill_joined_15mer_histo.txt 2> temp/jellyfish/jellyfish_histo_err15.txt

jellyfish dump temp/jellyfish/louse_ill_joined_15mer_counts.jf 1> temp/jellyfish/louse_ill_joined_15mer_counts_dumps.fa 2> temp/jellyfish/jellyfish_dump_err15.txt
