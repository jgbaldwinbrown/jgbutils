#!/bin/bash
set -e

gunzip -c ./inter/full_sync_all.sync.gz | \
python3 ../assorted_converters/sync2freqtable.py \
> /home/jgbaldwinbrown/Documents/work_stuff/clam_shrimp/shrimp_assembly/sfs_plot/files/r_tables/sync2freq.txt
