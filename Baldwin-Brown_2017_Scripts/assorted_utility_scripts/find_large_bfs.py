#!/usr/bin/env python
import sys

cutoff = float(sys.argv[1])
col = int(sys.argv[2])

for line in sys.stdin:
    liner = line.rstrip('\n')
    sline = liner.split()
    if float(sline[col-1]) >= cutoff:
        print liner

