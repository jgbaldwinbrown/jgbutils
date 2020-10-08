#!/usr/bin/env python

import fileinput

q=False
falen=0
for e in enumerate(fileinput.input()):
    i=e[0]
    l=e[1].rstrip('\n')
    if i <=0:
        if l[0]==">":
            q=False
        elif l[0]=="@":
            q=True
        else:
            raise Exception("input must be fq or fa")
    if q and i % 4 == 1:
        print len(l)
    if not q:
        #print "not q"
        if not l[0] == ">":
            #print "header"
            falen = falen + len(l)
        if l[0] == ">" and falen>0:
            #print "length"
            print falen
            falen = 0

if not q and falen<0:
    print falen
