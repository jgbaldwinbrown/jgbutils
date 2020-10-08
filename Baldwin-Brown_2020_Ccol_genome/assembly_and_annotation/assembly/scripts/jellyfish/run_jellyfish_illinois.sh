#!/bin/bash
#$ -N jelly_pero
#$ -pe openmp 64
#$ -R Y
#$ -q bio,pub64,adl

# Go to the directory from which the job was launched.
#cd $SGE_O_WORKDIR

#module load jellyfish

a=raw_data/louse_data_sra/second_srr_from_bioproject/SRR3161917.fastq

jellyfish count -m 21 -s 3000M -t 16 -o temp/jellyfish/illinois_louse_ill_joined_21mer_counts.jf -C $(echo $a) 1> temp/jellyfish/jellyfish_illinois_count_out.txt 2> temp/jellyfish/jellyfish_illinois_count_err.txt
#66 threads, 3 billion hash elements, 21mers.

jellyfish histo temp/jellyfish/illinois_louse_ill_joined_21mer_counts.jf  1> temp/jellyfish/illinois_louse_ill_joined_21mer_histo.txt 2> temp/jellyfish/jellyfish_illinois_histo_err.txt

jellyfish dump temp/jellyfish/illinois_louse_ill_joined_21mer_counts.jf 1> temp/jellyfish/illinois_louse_ill_joined_21mer_counts_dumps.fa 2> temp/jellyfish/jellyfish_illinois_dump_err.txt
