#!/usr/bin/env python
import fileinput

myset = set()
for line in fileinput.input():
    num = int(line.rstrip('\n').split()[0].split('s')[-1])
    myset.add(num)

for i in range(1,2045876):
    if not i in myset:
        print i

