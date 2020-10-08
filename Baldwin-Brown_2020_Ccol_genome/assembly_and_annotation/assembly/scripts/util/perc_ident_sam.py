#!/usr/bin/env python

import fileinput

for l in fileinput.input():
    if not l[0] == "@":
        md=""
        cigar=""
        sl=l.split()
        cigar = sl[5]
        for i in sl:
            if i[0:5] == "MD:Z:":
                md = i[5:]
        if len(cigar) > 0 and len(md) > 0:
            
