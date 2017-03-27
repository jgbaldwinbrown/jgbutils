#!/usr/bin/env python
import fileinput
from operator import itemgetter

all = [line.strip().split() for line in fileinput.input()]
#all = map(lambda(x): [int(x[0]),int(x[1]),float(x[2]),x[3],int(x[4]),int(x[5]),int(x[6]),float(x[7])],all)
all = sorted(all,key=lambda x: (int(x[-3]), int(x[-4])))
for entry in all:
    print "\t".join(map(str,entry))

