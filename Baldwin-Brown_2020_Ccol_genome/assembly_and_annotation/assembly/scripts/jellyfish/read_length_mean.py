#!/usr/bin/env python

import fileinput

def mean(data):
    """Return the sample arithmetic mean of data."""
    n = len(data)
    if n < 1:
        raise ValueError('mean requires at least one data point')
    #return sum(data)/n # in Python 2 use sum(data)/float(n)
    return sum(data)/float(n)

mycount=0
mysum=0

for e in enumerate(fileinput.input()):
    i=e[0]
    l=e[1].rstrip('\n')
    if i%4==1:
        mycount = mycount+1
        mysum = mysum + len(l)

myavg = float(mysum) / float(mycount)
print(myavg)

