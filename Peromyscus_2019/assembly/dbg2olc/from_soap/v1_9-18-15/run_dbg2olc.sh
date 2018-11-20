#!/bin/bash
#$ -N dbg2olc_pero_soap
#$ -pe openmp 1
#$ -R N
#$ -q bio,pub64

# Go to the directory from which the job was launched.
cd $SGE_O_WORKDIR

#/dfs1/bio/jbaldwi1/programs/dbg2olc/Programs

./DBG2OLC_Linux k 17 KmerCovTh 2 MinOverlap 20 AdaptiveTh 0.002 LD1 0 MinLen 200 Contigs /dfs2/temp/bio/jbaldwi1/peromyscus_data/work/dbg2olc/from_soap/v1_9-18-15/ill_assembly/pero_assembly_soap.scafSeq RemoveChimera 1 f /dfs2/temp/bio/jbaldwi1/peromyscus_data/data/pacbio/1-5_combo/pero_pacbio_1-5_combo.fasta
