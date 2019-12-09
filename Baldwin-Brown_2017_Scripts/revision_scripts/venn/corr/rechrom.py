#!/usr/bin/env python3

a = [x.rstrip('\n').split('\t') for x in open("headers_numbered6.txt", "r")]

with open("bigdata2_sigbed_rechrom.bed", "w") as outconn:
    for l in open("bigdata2_sigbed.bed", "r"):
        sl = l.rstrip('\n').split('\t')
        chromnum = int(sl[0])
        chrom = a[chromnum - 1][0]
        sl[0] = chrom
        outconn.write("\t".join(sl) + "\n")
