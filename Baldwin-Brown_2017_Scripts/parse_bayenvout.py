#!/usr/bin/python

import sys

baydatapath = sys.argv[1]
snptablepath = sys.argv[2]

snptable = {}
with open(snptablepath,"r") as file:
    for entry in enumerate(file):
        snptable[entry[0]] = entry[1].rstrip('\n').split()

with open(baydatapath) as bayfile:
    for line in bayfile:
        sline = line.rstrip('\n').split()
        snp_num = int(sline[0].split("_")[-1])
        prob = float(sline[1])
        chrom = snptable[snp_num][1]
        pos = snptable[snp_num][2]
        outline = "\t".join(map(str,[chrom,pos,prob,snp_num]))
        print outline

