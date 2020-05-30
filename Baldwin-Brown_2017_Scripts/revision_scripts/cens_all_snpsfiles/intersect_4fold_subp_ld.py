#!/usr/bin/env python3

import subprocess
import sys

def ld_filt(inpath, outpath1_bedified, ld_dist):
    with open(outpath1_bedified, "w") as outconn:
        prevchr = ""
        prevpos = -100000000000
        for i, l in enumerate(open(inpath, "r")):
            l = l.rstrip('\n')
            sl = l.split('\t')
            chr = sl[0]
            pos = int(sl[1])
            
            if chr != prevchr or (chr == prevchr and (pos - prevpos) >= ld_dist):
                outconn.write(l)
                outconn.write("\n")
                prevchr = chr
                prevpos = pos

def intersect_them(path1, path2, opath):
    with open(opath, "w") as oconn:
        subprocess.call([
               "bedtools",
               "intersect",
               "-wa",
               "-a",
               path1,
               "-b",
               path2
            ],
            stdout = oconn
        )
    #a.intersect(b, wa=True, stream=True).saveas(opath)

def bedify(path, opath, chrcol, poscol, header):
    header_string = None
    with open(opath, "w") as outconn:
        for i, l in enumerate(open(path, "r")):
            if i==0 and header:
                header_string = l.rstrip('\n')
                continue
            else:
                sl = l.rstrip('\n').split('\t')
                out = [sl[int(chrcol)].strip('"'), str(int(sl[int(poscol)].strip('"')) - 1), sl[int(poscol)].strip('"')]
                out.extend(sl)
                outconn.write("\t".join(out) + "\n")
    return(header_string)

def unbedify(bed, out, header, header_string):
    with open(out, "w") as outconn:
        if header:
            outconn.write(header_string + "\n")
        for l in open(bed, "r"):
            sl = l.rstrip('\n').split('\t')
            outconn.write("\t".join(sl[3:]) + "\n")

def cens_4deg(degs, inpath, outprefix, chrcol, poscol, header, ld_dist):
    bedified = outprefix + ".input.bedified.bed"
    header_string = bedify(inpath, bedified, chrcol, poscol, True)
    intersected = outprefix + ".bedified.bed"
    intersect_them(bedified, degs, intersected)
    out = outprefix + ".intersected.txt"
    unbedify(intersected, out, True, header_string)
    intersected_ldfilt = outprefix + ".ldfilt.bedified.bed"
    ld_filt(intersected, intersected_ldfilt, ld_dist)
    out_ldfilt = outprefix + ".ldfilt.intersected.txt"
    unbedify(intersected_ldfilt, out_ldfilt, True, header_string)

def main():
    degs = sys.argv[1]
    inpath = sys.argv[2]
    outprefix = sys.argv[3]
    chrcol = sys.argv[4]
    poscol = sys.argv[5]
    ld_dist = sys.argv[6]
    cens_4deg(degs, inpath, outprefix, chrcol, poscol, True, int(ld_dist))

if __name__ == "__main__":
    main()

