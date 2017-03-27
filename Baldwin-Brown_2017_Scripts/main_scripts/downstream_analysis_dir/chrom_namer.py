#!/usr/bin/env python

import sys

infile = sys.argv[1]
chromcol = int(sys.argv[2])
chromfile = sys.argv[3]
shifted = True if sys.argv[4]=="True" else False

headers = {}
for line in open(chromfile,"r"):
    sline = line.split()
    if not shifted:
        headers[int(float(sline[1]))] = sline[0]
    else:
        headers[int(float(sline[1]))+1] = sline[0]

for entry in enumerate(open(infile,"r")):
    index = entry[0]
    line = entry[1]
    if index == 0:
        print line.rstrip('\n')
        continue
    sline = line.split()
    chromnum = int(float(sline[chromcol]))
    chrom = headers[chromnum]
    sline[chromcol] = chrom
    print "\t".join(map(str,sline))


