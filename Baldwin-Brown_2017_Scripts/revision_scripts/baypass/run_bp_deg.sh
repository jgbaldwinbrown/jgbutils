#!/bin/bash
set -e

mkdir -p inter/bpout_deg

baypass -npop 11 \
    -gfile inter/snpsfile_deg.txt \
    -nthreads 6 \
    -poolsizefile data/poolsize.txt \
    -outprefix inter/bpout_deg/bpout_deg
