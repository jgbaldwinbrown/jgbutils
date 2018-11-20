#!/usr/bin/env python

import fileinput

indelcon = fileinput.input()

loclist = []
chrom=""
print "\t".join(["chrom","start","end","diff"])

for l in indelcon:
    sl = l.rstrip('\n').split('\t')
    newchrom = sl[0]
    if not newchrom == chrom:
        if len(loclist) > 0:
            loclist.append([end,1000000000000,diff])
            for i in xrange(len(loclist)):
                print "\t".join(map(str,[chrom,loclist[i][0],loclist[i][1],loclist[i][2]]))
        end = 1
        diff=0
        loclist = []
    chrom=newchrom
    muttype = sl[2]
    start = int(sl[3])
    loclist.append([end,start,diff])
    end = int(sl[4])
    reflen = len(sl[8].split(';')[0].split('=')[1])
    varlen = len(sl[8].split(';')[1].split('=')[1])
    if muttype == "insertion":
        end = end + 1
        diff = diff + varlen
    elif muttype == "deletion":
        end = end + 1
        diff = diff - reflen

if len(loclist) > 0:
    for i in xrange(len(loclist)):
        print "\t".join(map(str,[chrom,loclist[i][0],loclist[i][1],loclist[i][2]]))

