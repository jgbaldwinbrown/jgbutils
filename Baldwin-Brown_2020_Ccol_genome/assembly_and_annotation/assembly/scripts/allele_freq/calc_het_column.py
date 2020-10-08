#!/usr/bin/env python

import sys
import math

inpath=sys.argv[1]
outprefix=sys.argv[2]
incol=int(sys.argv[3])
gensize=int(sys.argv[4])

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
        #lcount=int(sl[6])
        #pcount=int(round(freq*float(lcount)))
        #qcount=lcount-pcount
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

#taxon.5.500.180_contig_72       5048    5049    A       ATGG    0.60264901      151
#taxon.5.500.180_contig_72       5050    5051    A       AGTT    0.64748201      139
#taxon.5.500.180_contig_72       6540    6541    AC      A       0.55147059      136
#taxon.5.500.180_contig_72       6726    6727    A       AT      0.45000000      120
#taxon.5.500.180_contig_220      13284   13285   TA      T       0.58558559      111
#taxon.5.500.180_contig_344      7390    7391    CAAGA   C       0.70229008      131
#taxon.5.500.180_contig_378      3124    3125    G       GCGGAATTTTTTC   0.38392857      112
#taxon.5.500.180_contig_378      3151    3152    AC      A       0.32738095      168
#taxon.5.500.180_contig_378      3223    3224    T       TTC     0.40404040      99
#taxon.5.500.180_contig_400      6567    6568    GT      G       0.53174603      126

#all pedcons2:
#35235095 bp

