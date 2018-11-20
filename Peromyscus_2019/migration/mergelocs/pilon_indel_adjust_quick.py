#!/usr/bin/env python

import fileinput

indelcon = fileinput.input()

loclist = []
chrom=""
print "\t".join(["chrom","start","end","diff"])

for l in indelcon:
    sl = l.rstrip('\n').split(' ')
    newchrom = sl[2].split(":")[0]
    if not newchrom == chrom:
        if len(loclist) > 0:
            loclist.append([end,1000000000000,diff])
            for i in xrange(len(loclist)):
                print "\t".join(map(str,[chrom,loclist[i][0],loclist[i][1],loclist[i][2]]))
        end = 1
        diff=0
        loclist = []
    chrom=newchrom
    start = int(sl[3])
    loss = -int(sl[4])
    gain = int(sl[5])
    tempdiff = gain - loss
    absdiff = abs(tempdiff)
    muttype = "insertion" if gain > loss else "deletion"
    #muttype = sl[2]
    #start = int(sl[3])
    loclist.append([end,start,diff])
    end = start if gain > loss else (start+gain-loss)
    #end = int(sl[4])
    if muttype == "insertion":
        end = end + 1
        diff = diff + absdiff
    elif muttype == "deletion":
        end = end + 1
        diff = diff - absdiff

if len(loclist) > 0:
    for i in xrange(len(loclist)):
        print "\t".join(map(str,[chrom,loclist[i][0],loclist[i][1],loclist[i][2]]))

