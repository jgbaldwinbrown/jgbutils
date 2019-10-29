#!/bin/bash
set -e

mkdir -p test4out
baypass -npop 18 -gfile data/geno.bta14mini -outprefix test4out/ana1
