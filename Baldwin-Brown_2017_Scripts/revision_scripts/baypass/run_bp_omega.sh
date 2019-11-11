#!/bin/bash
set -e

mkdir -p inter/bpout_omega

baypass -npop 11 \
    -gfile inter/snpsfile.txt \
    -nthreads 6 \
    -poolsizefile data/poolsize.txt \
    -omegafile inter/bpout_deg/bpout_deg_mat_omega.out \
    -outprefix inter/bpout_omega/bpout_omega
