#!/usr/bin/env python

import sys
import math

inpath=sys.argv[1]
outprefix=sys.argv[2]
gensize=int(sys.argv[3])

fulloutpath=outprefix+"_hets.txt"
meanoutpath=outprefix+"_avg_het.txt"

fullout=open(fulloutpath,"w")
meanout=open(meanoutpath,"w")

hetsum=0.0
for e in enumerate(open(inpath,"r")):
    i=e[0]
    l=e[1].rstrip('\n')
    sl=l.split('\t')
    if i==0:
        fullout.write(l+"\theterozygosity\n")
        continue
    try:
        freq=float(sl[5])
        lcount=int(sl[6])
        pcount=int(round(freq*float(lcount)))
        qcount=lcount-pcount
        p=freq
        q=1-p
    except ValueError:
        continue
    het=2*float(p)*float(q)
    fullout.write(l+"\t"+str(het)+"\n")
    hetsum = hetsum+het

avghet=float(hetsum)/float(gensize)
meanout.write("average heterozygosity for "+str(inpath)+":\n")
meanout.write(str(avghet)+"\n")

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

#all pedcons2:
#35235095 bp
