#!/usr/bin/env python
import fileinput

data = [line.rstrip('\n') for line in fileinput.input()]

sdata = sorted(data,key=lambda x: int(x.split()[0].split("s")[1]))

del data

for entry in sdata:
    print entry


