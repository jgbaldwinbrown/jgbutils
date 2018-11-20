#!/usr/bin/env python

import sys

args = sys.argv[1:]
bedpath = args[0]
convpath = args[1]

conv={}
for e in enumerate(open(convpath,"r")):
    i=e[0]
    l=e[1]
    if i<=0:
        continue
    sl=l.rstrip('\n').split()
    chrom = sl[0]
    if not chrom in conv:
        conv[chrom]=[]
    conv[chrom].append(map(int,sl[1:]))

#conv=[x.rstrip('\n').split() for x in open(convpath,"r")]

for l in open(bedpath,"r"):
    sl=l.rstrip('\n').split('\t')
    chrom,start,end = sl[0], int(sl[1]), int(sl[2])
    if chrom in conv:
        found=False
        for i in conv[chrom]:
            if start >= i[0] and start <= i[1]:
                diff=i[2]
                newstart=start+diff
                newend=end+diff
                found=True
        if not found:
            newstart="NA"
            newend="NA"
    else:
        newstart=start
        newend=end
    print "\t".join(map(str,[chrom,newstart,newend]))

