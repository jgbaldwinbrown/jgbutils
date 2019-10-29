#!/bin/bash
set -e

mkdir -p test2out
baypass -npop 18 -gfile data/geno.bta14 -nthreads 6 -outprefix test2out/ana1
