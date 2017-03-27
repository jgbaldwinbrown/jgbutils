#!/usr/bin/env python

import sys
from itertools import izip_longest

args = sys.argv
lfmm_inpath = args[1]
snptable_inpath = args[2]
lfmmcols = args[3].split(",")
snptablecols = args[4].split(",")

lfmm = open(lfmm_inpath,"r")
snptable = open(snptable_inpath,"r")
header = snptable.readline()
for lentry,sentry in izip_longest(lfmm,snptable):
    slentry = lentry.split()
    ssentry = sentry.split()
    lout = [slentry[x] for x in lfmmcols]
    sout = [ssentry[x] for x in snptablecols]
    out = sout.extend(lout)
    print "\t".join(map(str,out))

