#!/usr/bin/env python
import fileinput

for entry in enumerate(fileinput.input()):
    index = entry[0]
    line = entry[1]
    sline = line.rstrip('\n').split()
    if index == 0:
        print "\t".join(sline[:-2])
    else:
        f2s = sline[7]
        c2s = sline[8]
        f12s = sline[27]
        c12s = sline[28]
        if f2s == "NA":
            if f12s == "NA":
                ctot = 0
                ftot = 0.0
            else:
                ftot = float(f12s)
                ctot = int(c12s)
        elif f12s == "NA":
            ftot = float(f2s)
            ctot = int(c2s)
        else:         
            f2 = float(f2s)
            c2 = int(c2s)
            f12 = float(f12s)
            c12 = int(c12s)
            ctot = c2 + c12
            ftot = ((f2 * c2) + (f12 * c12)) / ctot
        outlist = sline[:-2]
        outlist[7] = ftot
        outlist[8] = ctot
        print "\t".join(map(str,outlist))

