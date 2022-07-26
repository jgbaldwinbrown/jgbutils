#!/bin/bash
set -e

cp /home/jgbaldwinbrown/Documents/git_repositories/louse_genome/louse_annotation_0.1.1.gff ./

gffread \
    louse_annotation_0.1.1.gff \
    -T \
    -o louse_annotation_0.1.1.gtf

rm louse_annotation_0.1.1.gff
