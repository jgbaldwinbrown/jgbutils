#!/usr/bin/env python
import sys

pattern = sys.argv[1]
filepath = sys.argv[2]

head = ""
seq = ""

for l in open(filepath,"r"):
    if l[0] == ">":
        if len(head) > 0 and head[1:]==pattern:
            print head
            print seq
        head = l.rstrip('\n')
        seq = ""
    else:
        seq = seq + l.rstrip('\n')

if len(head) > 0 and head[1:]==pattern:
    print head
    print seq

