#!/bin/bash
#$ -N jelly_pero
#$ -pe openmp 64
#$ -R Y
#$ -q bio,pub64,adl

# Go to the directory from which the job was launched.
#cd $SGE_O_WORKDIR

#module load jellyfish

#a="/data1/jbrown/louse_project/raw_data/louse_from_mike_dir/duplicates_removed/columbicola_180_seqyclean_PE1.fastq.gz /data1/jbrown/louse_project/raw_data/louse_from_mike_dir/duplicates_removed/columbicola_180_seqyclean_PE2.fastq.gz"

gunzip -c /data1/jbrown/louse_project/raw_data/louse_from_mike_dir/duplicates_removed/columbicola_180_seqyclean_PE1.fastq.gz > temp/jellyfish/unfilt_f.fq
gunzip -c /data1/jbrown/louse_project/raw_data/louse_from_mike_dir/duplicates_removed/columbicola_180_seqyclean_PE2.fastq.gz > temp/jellyfish/unfilt_r.fq

jellyfish count -m 21 -s 3000M -t 16 -o temp/jellyfish/louse_ill_joined_21mer_counts_unfiltered.jf -C temp/jellyfish/unfilt_f.fq temp/jellyfish/unfilt_r.fq 1> temp/jellyfish/jellyfish_count_out_unfiltered.txt 2> temp/jellyfish/jellyfish_count_err_unfiltered.txt
#66 threads, 3 billion hash elements, 21mers_unfiltered.

jellyfish histo temp/jellyfish/louse_ill_joined_21mer_counts_unfiltered.jf  1> temp/jellyfish/louse_ill_joined_21mer_histo_unfiltered.txt 2> temp/jellyfish/jellyfish_histo_err_unfiltered.txt

jellyfish dump temp/jellyfish/louse_ill_joined_21mer_counts_unfiltered.jf 1> temp/jellyfish/louse_ill_joined_21mer_counts_dumps_unfiltered.fa 2> temp/jellyfish/jellyfish_dump_err_unfiltered.txt
