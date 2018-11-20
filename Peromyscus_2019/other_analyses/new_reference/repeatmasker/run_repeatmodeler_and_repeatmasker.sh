#!/bin/bash
#$ -N repmask
#$ -pe openmp 1-64
#$ -ckpt restart
#$ -q bio,abio,free64,pub64,free48

module load repeatmasker
module load repeatmodeler

BuildDatabase -name pleucopus_v2 Freeze_PP.fa
RepeatModeler -pa $CORES -database pleucopus_v2 >& repeatmodeler_out.txt
RepeatMasker Freeze_PP.fa -lib consensi.fa.classified -gff -pa $CORES
