#!/bin/bash

set -e

samtools mpileup -C50 -f data/ref/shrimp_qmerged.quiver.fasta data/merged-realigned.bam > inter/merged-realigned.mpileup
pigz -p 7 inter/merged-realigned.mpileup > inter/merged-realigned.mpileup.gz
