#!/usr/bin/env python
import sys
import itertools

args=sys.argv
in1 = args[1]
incol = args[2]

inf1 = open(in1,"r")

outcolsinds1 = map(int,incol.split(","))

outcolsinds2 = range(0,5)
for i in outcolsinds1:
    outcolsinds2.append(i*2+3)
    outcolsinds2.append(i*2+4)


for i in inf1:
    si = i.split()
    outlist = [si[x] for x in outcolsinds2]
    print "\t".join(map(str,outlist))

