#!/usr/bin/env python

import sys

args = sys.argv[1:]

m8inpath = args[0]
acc2taxinpath = args[1]
good_taxids = set(args[2].split(","))

#build the dict containing the acc2taxid info:

good_accs = set([])
for e in enumerate(open(acc2taxinpath,"r")):
    i = e[0]
    l = e[1].rstrip('\n')
    if i <= 0:
        continue
    else:
        sl = l.split()
        taxid = sl[2]
        if taxid in good_taxids:
            acc = sl[1]
            good_accs.add(acc)

#filter the m8file by the presence of good acc's:

for l in open(m8inpath,"r"):
    l=l.rstrip('\n')
    sl=l.split()
    acc=sl[1]
    if acc in good_accs:
        print l


