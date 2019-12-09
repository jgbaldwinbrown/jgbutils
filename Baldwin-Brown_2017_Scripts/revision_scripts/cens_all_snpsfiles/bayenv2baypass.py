#!/usr/bin/env python3

import fileinput

for e, l in enumerate(fileinput.input()):
    if e % 2 == 0:
        sl1 = l.rstrip('\n').split('\t')
    else:
        sl2 = l.rstrip('\n').split('\t')
        out = []
        for ac1, ac2 in zip(sl1, sl2):
            out.extend([ac1, ac2])
        print("\t".join(out))
