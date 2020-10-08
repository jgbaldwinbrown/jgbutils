#!/bin/bash
#$ -N pero_falcon
#$ -q som,bio


. /dfs1/bio/mchakrab/pacbio/FALCON-integrate/fc_env/bin/activate
fc_run.py /bio/jbaldwi1/all_data_from_dfs2/peromyscus_data/work/falcon/pero.cfg
