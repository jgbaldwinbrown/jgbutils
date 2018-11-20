#!/bin/bash
#$ -N blamicv3
#$ -q bio,pub64
#$ -pe openmp 1
#$ -R y
##$ -hold_jid blastdb
module load enthought_python
module load bwa
module load samtools
module load picard-tools/1.96
module load blast/2.2.30

#names=(gene_extended2000
#three_prime_UTR
#intron
#translation
#transcript
#pseudogene
#gene
#exon)

#jobnum=`echo "$SGE_TASK_ID - 1" | bc`
#name=translation
#name2=translation_tblastn

tblastx -db ../blastdb/shrimp_ref_blastdb/shrimp_ref_v2_nucl_db -query /dfs2/temp/bio/jbaldwi1/shrimp_data/blast_alignments/final_assembly_version_9-30-15/microsats_etexana/cs11_cuts/cs11_primers_extended.fasta -out /dfs2/temp/bio/jbaldwi1/shrimp_data/blast_alignments/final_assembly_version_9-30-15/microsats_etexana/cs11_cuts/cs11_primers_extended.out -evalue 1e-5 -outfmt 6 -num_descriptions 1 -num_alignments 1

#tblastx -db ../blastdb/shrimp_ref_blastdb/shrimp_ref_v2_nucl_db -query /dfs2/temp/bio/jbaldwi1/shrimp_data/blast_alignments/final_assembly_version_9-30-15/microsats_etexana/microsatellite_all_origins.fasta -out /dfs2/temp/bio/jbaldwi1/shrimp_data/blast_alignments/final_assembly_version_9-30-15/microsats_etexana/microsatellite_all_origins.out -evalue 1e-5 -outfmt 6 -num_descriptions 1 -num_alignments 1

#makeblastdb -in data/trinity/Trinity.fasta -dbtype nucl -parse_seqids -out shrimp_trinity_blastdb_nucl

#blastn -db nr -query sub${SGE_TASK_ID}.fa -out results${SGE_TASK_ID}.out -evalue 1e-5 -outfmt 6 -num_descriptions 1 -num_alignments 1 -remote

