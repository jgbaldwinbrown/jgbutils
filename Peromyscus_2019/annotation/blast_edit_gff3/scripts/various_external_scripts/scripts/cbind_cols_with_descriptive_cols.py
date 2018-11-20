#!/usr/bin/env python
import sys
import itertools

args=sys.argv
in1 = args[1]
incol1 = int(args[2])
in2 = args[3]
incol2 = int(args[4])

inf1 = open(in1,"r")
inf2 = open(in2,"r")

outfreqcol1 = incol1 * 2 + 3
outfreqcol2 = incol2 * 2 + 3

for i1,i2 in itertools.izip(inf1,inf2):
    si1 = i1.split()
    si2 = i2.split()
    headcols = si1[0:5]
    outcols1 = si1[outfreqcol1:outfreqcol1+2]
    outcols2 = si2[outfreqcol2:outfreqcol2+2]
    outlist = headcols + outcols1 + outcols2
    print "\t".join(map(str,outlist))
    #print str(i1.split()[incol1]) + "\t" + str(i2.split()[incol2])

