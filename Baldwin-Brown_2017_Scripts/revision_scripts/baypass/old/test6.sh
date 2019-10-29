#!/bin/bash
set -e

mkdir -p test5out
baypass -npop 12 -gfile data/lsa.geno -nthreads 6 -poolsizefile data/lsa.poolsize -outprefix test6out/lsa1
