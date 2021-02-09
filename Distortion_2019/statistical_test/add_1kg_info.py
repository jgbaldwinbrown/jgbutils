#!/usr/bin/env python3

import sys
import re

regex = re.compile(r'\bbam$')

for l in sys.stdin:
    l=l.rstrip('\n')
    if regex.search(l):
        name = l.split(".")[0]
        print("1000G", name, name, "Blood", name, sep="\t")
    else:
        print(l)


#Significant	D167	JGB00005	Sperm	15458X1
#Significant	UC4M017	JGB00006	Sperm	15458X2
#Significant	D240	JGB00007	Sperm	15458X3
#Non-significant	D265	JGB00008	Blood	15458X4
#HG00146.mapped.ILLUMINA.bwa.GBR.low_coverage.20120522.bam
#HG00148.mapped.ILLUMINA.bwa.GBR.low_coverage.20121211.bam
#HG00149.mapped.ILLUMINA.bwa.GBR.low_coverage.20121211.bam
#HG00150.mapped.ILLUMINA.bwa.GBR.low_coverage.20120522.bam
