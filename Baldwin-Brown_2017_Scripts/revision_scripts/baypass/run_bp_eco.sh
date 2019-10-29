#!/bin/bash
set -e

mkdir -p inter/bpout

baypass -npop 11 \
    -gfile snpsfile.txt \
    -nthreads 6 \
    -efile data/ecovars.txt \
    -poolsizefile data/poolsize.txt \
    -outprefix inter/bpout_eco/bpout
