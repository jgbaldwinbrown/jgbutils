#!/bin/bash
set -e

mkdir -p inter/bpout_eco_omega

baypass -npop 11 \
    -gfile inter/snpsfile.txt \
    -nthreads 6 \
    -efile data/ecovars.txt \
    -poolsizefile data/poolsize.txt \
    -omegafile inter/bpout_deg/bpout_deg_mat_omega.out \
    -outprefix inter/bpout_eco_omega/bpout_eco_omega
