#!/usr/bin/env python

import sys
import itertools

i1 = sys.argv[1]
i2 = sys.argv[2]

ic1 = open(i1,"r")
ic2 = open(i2,"r")

for i,ls in enumerate(itertools.izip(ic1,ic2)):
    l1=ls[0]
    l2=ls[1]
    if i <= 1:
        print l1.rstrip('\n')
        continue
    sl1 = l1.strip('\n').split('\t')
    sl2 = l2.strip('\n').split('\t')
    n1 = int(sl1[-1])
    n2 = int(sl2[-1])
    n_out = n1+n2
    out = [x for x in sl1[:-1]]
    out.append(str(n_out))
    print "\t".join(out)

