#!/bin/bash
#$ -N jelly_pero
#$ -pe openmp 64
#$ -R Y
#$ -q bio,pub64

# Go to the directory from which the job was launched.
cd $SGE_O_WORKDIR

module load jellyfish

jellyfish count -m 21 -s 3000M -t 64 -o pero_ill_mer_counts.jf -C <(zcat ../../data/illumina/1/R231-L1-READ1-Sequences.txt.gz) <(zcat ../../data/illumina/1/R231-L1-READ2-Sequences.txt.gz) <(zcat ../../data/illumina/2/R235-L2-READ2-Sequences.txt.gz) <(zcat ../../data/illumina/2/R235-L3-READ2-Sequences.txt.gz) <(zcat ../../data/illumina/2/R235-L2-READ1-Sequences.txt.gz) <(zcat ../../data/illumina/2/R235-L1-READ1-Sequences.txt.gz) <(zcat ../../data/illumina/2/R235-L3-READ1-Sequences.txt.gz) <(zcat ../../data/illumina/2/R235-L1-READ2-Sequences.txt.gz)
#64 threads, 3 billion hash elements, 21mers.

jellyfish histo pero_ill_mer_counts.jf

#jellyfish dump pero_ill_mer_counts.jf > pero_ill_mer_counts_dumps.fa
#files:
#/dfs2/temp/bio/jbaldwi1/peromyscus_data/data/illumina/1/R231-L1-READ1-Sequences.txt.gz
#/dfs2/temp/bio/jbaldwi1/peromyscus_data/data/illumina/1/R231-L1-READ2-Sequences.txt.gz
#/dfs2/temp/bio/jbaldwi1/peromyscus_data/data/illumina/2/R235-L2-READ2-Sequences.txt.gz
#/dfs2/temp/bio/jbaldwi1/peromyscus_data/data/illumina/2/R235-L3-READ2-Sequences.txt.gz
#/dfs2/temp/bio/jbaldwi1/peromyscus_data/data/illumina/2/R235-L2-READ1-Sequences.txt.gz
#/dfs2/temp/bio/jbaldwi1/peromyscus_data/data/illumina/2/R235-L1-READ1-Sequences.txt.gz
#/dfs2/temp/bio/jbaldwi1/peromyscus_data/data/illumina/2/R235-L3-READ1-Sequences.txt.gz
#/dfs2/temp/bio/jbaldwi1/peromyscus_data/data/illumina/2/R235-L1-READ2-Sequences.txt.gz
