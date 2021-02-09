#!/bin/bash
set -e

mkdir -p out

if [ ! -f out/out.txt.done ] ; then
    blastn \
        -query louse/louseref.fa \
        -db db/db.fa \
        -outfmt 6 \
        -num_threads 8 \
        -out out/out.txt
    touch out.txt.done
fi
