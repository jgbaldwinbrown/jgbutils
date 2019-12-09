#!/usr/bin/env python3

import sys

def unbedify(bed, out, header, header_string):
    with open(out, "w") as outconn:
        if header:
            outconn.write(header_string + "\n")
        for l in open(bed, "r"):
            sl = l.rstrip('\n').split('\t')
            outconn.write("\t".join(sl[3:]) + "\n")

def main():
    inpath = sys.argv[1]
    outpath1_bedified = sys.argv[2]
    outpath2_unbedified = sys.argv[3]
    with open(outpath1_bedified, "w") as outconn:
        prevchr = ""
        prevpos = -100000000000
        for i, l in enumerate(open(inpath, "r")):
            l = l.rstrip('\n')
            sl = l.split('\t')
            chr = sl[0]
            pos = int(sl[1])
            
            if chr != prevchr or (chr == prevchr and (pos - prevpos) <= 100000:
                outconn.write(l)
                outconn.write("\n")
            
            prevchr = chr
            prevpos = pos
    header = 
    unbedify(outpath1_bedified, outpath2_unbedified, 

if __name__ == "__main__":
    main()
