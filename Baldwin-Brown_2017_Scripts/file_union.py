#!/usr/bin/env python
import sys

fa = sys.argv[1]
fb = sys.argv[2]

sa = set([int(line.strip()) for line in open(fa,"r")])
sb = set([int(line.strip()) for line in open(fb,"r")])

so = sa.union(sb)
so = sorted(list(so))

print "\n".join(map(str,so))

