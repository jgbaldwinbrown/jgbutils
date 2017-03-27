#!/usr/bin/env python
import sys
import itertools

args=sys.argv
in1 = args[1]
in2 = args[2]
incol2 = args[3]

inf1 = open(in1,"r")
inf2 = open(in2,"r")
outcolsinds = map(int,incol2.split(","))

for i1,i2 in itertools.izip(inf1,inf2):
    si1 = i1.split()
    si2 = i2.split()
    outcols = [si2[x] for x in outcolsinds]
    outlist = si1 + outcols
    print "\t".join(map(str,outlist))

