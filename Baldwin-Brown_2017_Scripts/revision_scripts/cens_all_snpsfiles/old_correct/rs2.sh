#!/bin/bash
set -e

rsync -avP . jbaldwi1@hpc.oit.uci.edu:/share/adl/jbaldwi1/all_data_from_dfs2/shrimp_data/revisions/baypass/censor_all_snpsfiles/old_correct
