#!/bin/bash

#actual run:

mkdir -p temp/binner/louse_clamshrimp_bigdb

/data1/jbrown/local_programs/Taxonomer_from_aurelie/Taxonomer_201602/bin_reads scripts/binner/louse_clamshrimp_bigdb.conf -c 0.3 >  temp/binner/louse_clamshrimp_bigdb/louse_clamshrimp_bigdb.log 2>&1

