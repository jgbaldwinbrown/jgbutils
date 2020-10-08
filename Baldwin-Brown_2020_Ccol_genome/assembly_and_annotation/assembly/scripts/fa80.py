#!/usr/bin/env python

import fileinput

head = ""
seq = ""
i=0

def seqprint(seq):
    print "\n".join([seq[i:i+80] for i in range(0, len(seq), 80)])

for line in fileinput.input():
    line = line.rstrip('\n')
    if line[0]==">":
        if i >= 1:
            print head
            seqprint(seq)
        head = line
        seq = ""
    else:
        seq = seq + line
    i = i+1

print head
seqprint(seq)
