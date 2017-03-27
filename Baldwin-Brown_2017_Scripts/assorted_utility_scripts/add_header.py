#!/usr/bin/env python

import fileinput

for entry in enumerate(fileinput.input()):
    index = entry[0]
    line = entry[1].rstrip('\n')
    if index == 0:
        numcol = len(line.split())
        repnum = (numcol - 6) / 3
        header = ["index","genpos"]
        rep1 = ["bf" for x in xrange(repnum)]
        rep2 = ["rho" for x in xrange(repnum)]
        rep3 = ["rs" for x in xrange(repnum)]
        #print rep1
        #print rep2
        #print rep3
        reptup = zip(rep1,rep2,rep3)
        #print reptup
        reps = [x for y in reptup for x in y]
        #print reps
        header.extend(reps)
        header.extend(["chrompos","chromnum","chromlen","xtx"])
        print "\t".join(map(str,header))
    print line

#chroms[index] = [chromname,chrompos,chromnum,chromlen]
#    outline = map(str,[index,genpos])
#    outline.extend(map(str,value))
#    outline.extend(map(str,[chrominfo[1],chrominfo[2],chrominfo[3],myxtxval]))
