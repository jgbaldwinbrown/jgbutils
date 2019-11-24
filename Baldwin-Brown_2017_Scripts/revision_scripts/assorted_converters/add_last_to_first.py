#!/usr/bin/env python3

import fileinput

for l in fileinput.input():
    sl = l.rstrip('\n').split('\t')
    sl[2] = str(int(sl[2]) + int(sl[-2]))
    sl[3] = str(int(sl[3]) + int(sl[-1]))
    print("\t".join(sl[:-2]))
