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

for i1,i2 in itertools.izip(inf1,inf2):
    print str(i1.split()[incol1]) + "\t" + str(i2.split()[incol2])

