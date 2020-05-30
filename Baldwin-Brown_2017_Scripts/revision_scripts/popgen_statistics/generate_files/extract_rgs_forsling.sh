#!/bin/bash
set -e

samtools view -b -r JBB_hb705_Lcombo merged-realigned-deduped2.bam 'ctg7180000000558|quiver|quiver|quiver' > forsling/JBB_hb705_unmerged_realigned_deduped2_forsling.bam
