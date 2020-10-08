#!/usr/bin/env python

import fileinput
import math

def n50_stats(x,halftot):
    templen=0
    numconts=0
    for i in x:
        templen=templen+i
        numconts=numconts+1
        if templen >= halftot:
            n50=i
            break
    return([i,templen,numconts])

def get_n50(n50_stats):
    return(n50_stats[0])

def get_bp_in_n50(n50_stats):
    return(n50_stats[1])

def get_l50(n50_stats):
    return(n50_stats[2])

def mean(x):
    return float(sum(x)) / max(len(x), 1)

header=""
seq=""
all_lengths=[]
for line in fileinput.input():
    line=line.rstrip('\n')
    if line[0]==">":
        if len(header)>0 and len(seq)>0:
            all_lengths.append(len(seq))
        header=line
        seq=""
    else:
        seq=seq+line

if len(header)>0 and len(seq)>0:
    all_lengths.append(len(seq))

totbp=sum(all_lengths)
halftot=int(math.ceil(float(totbp)/2.0))
revsort_lengths=sorted(all_lengths,reverse=True)

stats=n50_stats(revsort_lengths,halftot)
n50=get_n50(stats)
l50=get_l50(stats)
bp_in_n50=get_bp_in_n50(stats)
meanlength=mean(revsort_lengths)

print "total bp: " + str(int(totbp))
print "mean length: " + str(meanlength)
print "N50: " + str(int(n50))
print "L50: " + str(int(l50))
print "basepairs in N50: " + str(int(bp_in_n50))

