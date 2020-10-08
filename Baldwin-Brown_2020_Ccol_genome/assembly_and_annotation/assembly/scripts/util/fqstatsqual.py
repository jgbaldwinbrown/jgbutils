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

def probsfromphred(x):
    #input must be a string of phred-scaled ascii characters
    problist=[]
    for j in range(0,len(line)):
        phredscore = ord(line[j]) - 33
        probgood = 1 - (float(10) ** (-float(phredscore)/float(10)))
        problist.append(probgood)
    return(problist)

header=""
seq=""
all_lengths=[]
totqualperc=0
for entry in enumerate(fileinput.input()):
    index=entry[0]
    line=entry[1].rstrip('\n')
    if index % 4 == 0:
        if len(header)>0 and len(seq)>0:
            all_lengths.append(len(seq))
        header=line
        seq=""
    elif index % 4 == 1:
        seq=seq+line
    if index % 4 == 3:
        probs=probsfromphred(line)
        probsum=sum(probs)
        totqualperc = totqualperc + probsum

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
meanqual = float(totqualperc) / float(totbp)

print "total bp: " + str(int(totbp))
print "mean length: " + str(meanlength)
print "N50: " + str(int(n50))
print "L50: " + str(int(l50))
print "basepairs in N50: " + str(int(bp_in_n50))
print "mean quality score: " + str(meanqual)

