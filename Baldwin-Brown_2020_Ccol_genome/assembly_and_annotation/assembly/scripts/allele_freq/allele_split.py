#!/usr/bin/env python

import sys
import math

args=sys.argv[1:]

inpath=args[0]
outprefix=args[1]

polypath=outprefix+"_poly.txt"
f0path=outprefix+"_f0.txt"
f1path=outprefix+"_f1.txt"
badpath=outprefix+"_bad.txt"

f0=open(f0path,"w")
f1=open(f1path,"w")
poly=open(polypath,"w")
bad=open(badpath,"w")

all_outs=[f0,f1,poly,bad]

for e in enumerate(open(inpath,"r")):
    i=e[0]
    l=e[1].rstrip('\n')
    sl=l.split('\t')
    if i==0:
        for x in all_outs:
            x.write(l+"\n")
    try:
        freq=float(sl[5])
        lcount=int(sl[6])
        pcount=int(round(freq*float(lcount)))
        qcount=lcount-pcount
    except ValueError:
        bad.write(l+"\n")
        continue
    if lcount < 20:
        bad.write(l+"\n")
        continue
    if pcount <= 1:
        f0.write(l+"\n")
        continue
    if qcount <= 1:
        f1.write(l+"\n")
    else:
        poly.write(l+"\n")

f0.close()
f1.close()
poly.close()
bad.close()

#Nmiss   CHROM   POS     REF     ALT     freq_all_out    N_all_out
#0       taxon.5.500.180_contig_1        94      A       G       0.29411765      170
#0       taxon.5.500.180_contig_1        99      C       T       0.39873418      158
#0       taxon.5.500.180_contig_1        7930    A       T       0.73205742      209
#0       taxon.5.500.180_contig_1        8425    C       T       0.74000000      200
#0       taxon.5.500.180_contig_1        8526    G       A       0.74336283      226
#0       taxon.5.500.180_contig_3        80      C       A       0.61722488      209
#0       taxon.5.500.180_contig_3        104     G       C       0.44651163      215
#0       taxon.5.500.180_contig_3        125     G       A       0.43269231      208
#0       taxon.5.500.180_contig_3        162     G       A       0.61764706      170
