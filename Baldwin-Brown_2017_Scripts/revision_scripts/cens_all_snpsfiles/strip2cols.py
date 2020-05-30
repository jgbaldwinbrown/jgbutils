#!/usr/bin/env python3

import fileinput

for l in fileinput.input():
    sl = l.rstrip('\n').split('\t')
    print("\t".join(sl[:-2]))

