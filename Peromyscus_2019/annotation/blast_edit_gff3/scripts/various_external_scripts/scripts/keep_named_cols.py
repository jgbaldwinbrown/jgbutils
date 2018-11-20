#!/usr/bin/env python
import sys
import itertools

args=sys.argv
in1 = args[1]
incol = args[2]

inf1 = open(in1,"r")
#outcolsinds = map(int,incol.split(","))

for e in enumerate(inf1):
    i=e[0]
    l=e[1].rstrip('\n')
    sl = l.split()
    if i==0:
        outcolsinds=[]
        for i2 in incol.split(","):
            outcolsinds.append(sl.index(i2))
    outlist = [sl[x] for x in outcolsinds]
    print "\t".join(map(str,outlist))

