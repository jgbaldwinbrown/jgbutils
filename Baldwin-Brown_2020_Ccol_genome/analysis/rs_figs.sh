#!/bin/bash
set -e

rsync -avP \
    ./ \
    /home/jgbaldwinbrown/Documents/work_stuff/louse/papers/genome_paper/latex/figures/ \
    --files-from figs_list.txt
