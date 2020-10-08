#!/bin/bash
#$ -N repmask
#$ -pe openmp 1-64
#$ -ckpt restart
#$ -q bio,abio,free64,pub64,free48

module load repeatmasker
module load repeatmodeler

BuildDatabase -name pleucopus peromyscus_assembly_polished_v1.fasta
RepeatModeler -pa $CORES -database pleucopus >& repeatmodeler_out.txt
RepeatMasker peromyscus_assembly_polished_v1.fasta -lib consensi.fa.classified -gff -pa $CORES
