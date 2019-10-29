#!/bin/bash
set -e

mkdir -p inter/bpout

baypass -npop 11 \
    -gfile snpsfile_deg.txt \
    -nthreads 6 \
    -poolsizefile data/poolsize.txt \
    -outprefix inter/bpout_deg/bpout
