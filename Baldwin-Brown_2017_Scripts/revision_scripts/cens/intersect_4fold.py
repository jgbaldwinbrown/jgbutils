#!/usr/bin/env python3

import pybedtools

def intersect_them(path1, path2, opath):
    a = pybedtools.BedTool('path1.bed')
    b = pybedtools.BedTool('path2.bed')
    a.intersect(b, wa=True, stream=True).saveas(opath)

def bedify(path, opath, chrcol, poscol, header):
    header_string = None
    with open(opath, "w") as oconn:
        for i, l in enumerate(open(path, "r")):
            if i==0 and header:
                header+string = l.rstrip('\n')
                continue
            else:
                sl = l.rstrip('\n').split('\t')
                out = [sl[chrcol].strip('"'), str(int(sl[poscol].strip('"') - 1)), sl[poscol].strip('"')
                out.extend(sl)
                outconn.("\t".join(out) + "\n")
    return(header_string)

def unbedify(bed, out, header, header_string):
    with open(out, "w") as outconn:
        if header:
            outconn.write(header_string + "\n")
        for l in open(bed, "r"):
            sl = l.rstrip('\n').split('\t')
            outconn.write("\t".join(sl[3:]) + "\n")

def cens_4deg(degs, inpath, outprefix, chrcol, poscol, header):
    bedified = outprefix + ".input.bedified.bed"
    header_string = bedify(inpath, bedified, header=True)
    intersected = outprefix + ".bedified.bed"
    intersect_them(bedified, degs, intersected)
    out = outprefix + ".intersected.txt"
    unbedify(intersected, out, True, header_string)

def main():
    degs = sys.argv[1]
    inpath = sys.argv[2]
    outprefix = sys.argv[3]
    chrcol = sys.argv[4]
    poscol = sys.argv[5]
    cens_4deg(degs, inpath, outprefix)

if __name__ == "__main__":
    main()
