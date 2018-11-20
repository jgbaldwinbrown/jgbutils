#!/usr/bin/env python

import sys
from itertools import izip_longest

args = sys.argv
lfmm_inpath = args[1]
snptable_inpath = args[2]
lfmmcols = map(int,args[3].split(","))
snptablecols = map(int,args[4].split(","))

lfmm = open(lfmm_inpath,"r")
lheader=lfmm.readline()
snptable = open(snptable_inpath,"r")
sheader = snptable.readline()

for lentry,sentry in izip_longest(lfmm,snptable):
    slentry = lentry.split()
    ssentry = sentry.split()
    lout = [slentry[x] for x in lfmmcols]
    sout = [ssentry[x] for x in snptablecols]
    sout.extend(lout)
    print "\t".join(map(str,sout))

