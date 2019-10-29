#!/bin/bash
set -e

mkdir -p test5out
baypass -npop 12 -gfile data/lsa.geno -nthreads 6 -efile lsa.ecotype -poolsizefile data/lsa.poolsize -outprefix test7out/lsa1
