#!/usr/bin/env python

import sys

infile = sys.argv[1]
chromcol = int(sys.argv[2])
if len(sys.argv) >= 4:
    chromfile = sys.argv[3]
else:
    chromfile = False

headers = {}
curhead = 0
if chromfile:
    for line in open(chromfile,"r"):
        sline = line.split()
        headers[sline[0]] = sline[1]
else:
    for entry in enumerate(open(infile,"r")):
        if entry[0] == 0:
            continue
        sline = entry[1].split()
        chrom = sline[chromcol]
        if chrom not in headers:
            headers[chrom] = curhead
            curhead += 1

for entry in enumerate(open(infile,"r")):
    index = entry[0]
    line = entry[1]
    if index == 0:
        print line.rstrip('\n') + "\tchromnum"
        continue
    sline = line.split()
    chrom = sline[chromcol]
    chromnum = headers[chrom]
    print line.rstrip('\n') + "\t" + str(chromnum)

