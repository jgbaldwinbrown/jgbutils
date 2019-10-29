#!/bin/bash
set -e

mkdir -p test5out
baypass -npop 18 -gfile data/geno.bta14 -nthreads 6 -omegafile data/omega.bta -outprefix test5out/ana1
