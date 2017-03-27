#!/usr/bin/env python
import sys
import fileinput

#Chromosome      Start   End     Feature "adjusted.p.values"     lfmm_pcombo_win100

infile = sys.argv[1]
index = sys.argv[2]

opath = infile + "rehead"
with open(opath,"w") as ofile:
    for e in enumerate(fileinput.input(files=sys.argv[1:2])):
        i=e[0]
        l=e[1].rstrip('\n')
        if i==0:
            sl=l.split("\t")
            out=sl
            out[4] = "adjusted.p."+str(index)+".values"
            out[5] = "lfmm_pcombo_"+str(index)+"_win100"
            ofile.write("\t".join(map(str,out))+"\n")
            continue
        ofile.write(l+"\n")

