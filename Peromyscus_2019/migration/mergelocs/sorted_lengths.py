#!/usr/bin/env python

import fileinput

h=""
l=0
ll=[]
for line in fileinput.input():
    if line[0]==">" and l>0:
        ll.append(l)
        l=0
    else:
        l = l + len(line.rstrip('\n'))

ll.append(l)
l=0

sl = sorted(ll,reverse=True)
print "\n".join(map(str,sl))
