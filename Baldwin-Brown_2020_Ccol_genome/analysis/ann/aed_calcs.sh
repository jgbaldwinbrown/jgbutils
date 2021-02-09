#!/bin/bash
set -e

gunzip -c ../louseref.all.sprot.interproscan_tsv.clean.sorted.baccut.gff.gz | \
grep -o '_AED=[0-9.]*' | \
sed 's/.*=//' > aeds.txt

cat aeds.txt | \
awk '
$1>.5{
    bad+=1
}

$1==0{
    great+=1
}

END{
    printf("all: %d\ngood: %d\nbad: %d\naed=0: %d\nprop_aed0: %g\nprop: %g\n", NR, NR-bad, bad, great, great/NR, bad/NR)
}
' \
> aed_stats.txt
