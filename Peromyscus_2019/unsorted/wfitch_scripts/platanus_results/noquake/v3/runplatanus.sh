#!/bin/bash
#$ -N plat_pero
#$ -pe openmp 64
#$ -R Y
#$ -q som,bio,pub64

# Go to the directory from which the job was launched.
cd $SGE_O_WORKDIR

#PATH=$PATH\:/w2/jbaldwi1/allpaths-lg/bin ; export PATH

#module load gcc
#module load allpathslg

module load jbaldwi1/platanus/1.2.1/2015.8.25

#PATH=$PATH:/gl/bio/jbaldwi1/programs/platanus_1.2.1 ; export PATH

platanus assemble -t 64 -f /dfs2/temp/bio/jbaldwi1/peromyscus_data/data/illumina/combo/all_pero_ill.fa -o plat_assembly -m 512 1> plat_assembly_out.txt 2> plat_assembly_log.txt
#platanus scaffold -t 64 -c plat_assembly_contig.fa -b plat_assembly_contigBubble.fa -OP1 schatz_corrected_forward_3kb_outward.fq schatz_corrected_reverse_3kb_outward.fq -a1 3000 -d1 20 -OP2 schatz_corrected_forward_10kb_outward.fq schatz_corrected_reverse_10kb_outward.fq -a2 10000 -d2 20 1> plat_scaffold_out.txt 2> plat_scaffold_log.txt
#platanus gap_close -t 64 -c plat_assembly_scaffold.fa -OP1 schatz_corrected_forward_3kb_outward.fq schatz_corrected_reverse_3kb_outward.fq -OP2 schatz_corrected_forward_10kb_outward.fq schatz_corrected_reverse_10kb_outward.fq plat_gapclose_out.txt 2> plat_gapclose_log.txt
