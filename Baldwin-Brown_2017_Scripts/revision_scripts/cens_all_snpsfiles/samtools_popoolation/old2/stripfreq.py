#!/usr/bin/env python3

import fileinput

for i, l in enumerate(fileinput.input()):
    l=l.rstrip('\n')
    if i==0:
        print(l)
    else:
        sl = l.split('\t')
        print("\t".join(map(str, sl[1:-1])))
