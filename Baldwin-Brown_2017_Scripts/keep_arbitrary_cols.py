#!/usr/bin/env python
import sys
import itertools

args=sys.argv
in1 = args[1]
incol = args[2]

inf1 = open(in1,"r")
outcolsinds = map(int,incol.split(","))

for i in inf1:
    si = i.split()
    outlist = [si[x] for x in outcolsinds]
    print "\t".join(map(str,outlist))

