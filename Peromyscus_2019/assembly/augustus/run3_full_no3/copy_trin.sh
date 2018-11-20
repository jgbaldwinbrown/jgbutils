#!/bin/bash
#$ -N tc
#$ -q bio,abio,pub64,free64,adl
#$ -ckpt restart
#$ -hold_jid t

rsync -avP /bio/jbaldwi1/all_data_from_dfs2/peromyscus_data/work/trinity/v5_all_data_no3/trinity_output/Trinity.fasta trinity_out/
