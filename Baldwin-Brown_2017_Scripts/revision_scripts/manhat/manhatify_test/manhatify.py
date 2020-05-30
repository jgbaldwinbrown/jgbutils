#!/usr/bin/env python3

import sys

def manhatify(bedconn, dataconn, datacol, outprefix, chrs, header):
    with open(outprefix+"_chrnames.txt", "w") as chrout, open(outprefix+"_manhat_format.txt", "w") as manhatout:
        if header:
            trash = dataconn.readline()
        manhatout.write("SNP\tCHR\tBP\tP\n")
        for l1, l2 in zip(bedconn, dataconn):
            sl1 = l1.rstrip('\n').split()
            sl2 = l2.rstrip('\n').split()
            chrom = sl1[0]
            if chrom not in chrs:
                sys.exit("missing chrom: " + chrom)
            nchrom = chrs[chrom]
            out = [0, nchrom, sl1[2], sl2[datacol]]
            manhatout.write("\t".join(map(str, out)) + "\n")

def main():
    chrs = {}
    if sys.argv[4] == "True":
        header = True
    else:
        header = False
    for l in open("headers_numbered6.txt", "r"):
        sl = l.rstrip('\n').split()
        chrs[sl[0]] = sl[3]
    manhatify(open(sys.argv[1], "r"), open(sys.argv[2], "r"), int(sys.argv[5]), sys.argv[3], chrs, header)

if __name__ == "__main__":
    main()

#==> censbed.bed <==
#Backbone_105/0_36014|quiver|quiver|quiver	11318	11319
#Backbone_105/0_36014|quiver|quiver|quiver	11349	11350
#Backbone_105/0_36014|quiver|quiver|quiver	11356	11357
#Backbone_105/0_36014|quiver|quiver|quiver	11361	11362
#Backbone_105/0_36014|quiver|quiver|quiver	11398	11399
#Backbone_105/0_36014|quiver|quiver|quiver	11413	11414
#Backbone_105/0_36014|quiver|quiver|quiver	11751	11752
#Backbone_105/0_36014|quiver|quiver|quiver	11764	11765
#Backbone_105/0_36014|quiver|quiver|quiver	11878	11879
#Backbone_105/0_36014|quiver|quiver|quiver	11887	11888
#
#==> full_fst_hap2.txt <==
#0.3174478
#0.566965
#0.2325461
#0.3890584
#0.2725197
#0.253707
#0.1198363
#0.1122847
#0.1649112
#0.1930199
