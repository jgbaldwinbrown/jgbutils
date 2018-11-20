#!/usr/bin/env

import sys
from operator import itemgetter

inpath = sys.argv[1]
outprefix = sys.argv[2]
thresh = int(sys.argv[3])

seqs = []
header = ""
seq = ""
for line in open(inpath,"r"):
    line = line.rstrip('\n')
    if line[0] == ">":
        if len(header) >= 0 and len(seq) >= 0:
            seqs.append([header,seq,len(seq)])
        header = line
        seq = ""
        #seqs.append([line,"",0])
    else:
        seq += line
        #seqs[-1][1] += line


#for entry in seqs:
#    entry[2] = len(entry[1])

seqs = sorted(seqs,key=itemgetter(2),reverse=True)

outsuf = 0
remainder_list=[]
for entry in seqs:
    header = entry[0]
    seq = entry[1]
    length = entry[2]
    if length >= thresh:
        outpath = outprefix + str(outsuf) + ".fasta"
        with open(outpath,"w") as file:
            file.write(header + "\n")
            file.write(seq + "\n")
        outsuf += 1
    else:
        remainder_list.append(entry)

with open("therest.fasta","w") as file:
    for entry in remainder_list:
        header = entry[0]
        seq = entry[1]
        length = entry[2]
        file.write(header + "\n")
        file.write(seq + "\n")

