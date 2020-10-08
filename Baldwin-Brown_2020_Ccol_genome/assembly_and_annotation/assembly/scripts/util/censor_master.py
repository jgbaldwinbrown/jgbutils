#!/usr/bin/env python
import sys
import argparse

parser=argparse.ArgumentParser(description = "censor SNP table based on a table of known good SNPs")
parser.add_argument("snptable",help="the SNP table to be censored")
parser.add_argument("good_snps", help="list of known good SNPs (each line should contain the SNP number and a value of 'Good' or 'Bad'")
parser.add_argument("--header", help="boolean value indicating if the snptable has a header line",action="store_true")
parser.add_argument("-c","--column", help="column containing SNP number (by default, SNP order in file is used)")
parser.add_argument("-g","--goodval", help="value from 'good_snps' to indicate good SNPs. By default, either 'Good', 'good', 'GOOD', 'True', 'true', or 'TRUE'.")
parser.add_argument("-z","--notzero", help="boolean value indicating that good snp indices start at '1' instead of '0', while the snptable starts at 0",action="store_true")

args = parser.parse_args()
snptablepath = args.snptable
goodsnppath = args.good_snps
if args.header:
    header=True
else:
    header=False
if args.column:
    cols = True
    snpindexcol = int(args.column)
else: cols=False
goodvals = ["Good","good","GOOD","True","true","TRUE"]
if args.goodval:
    goodvals.append(args.goodval)
if args.notzero:
    notzero = True
else:
    notzero = False

goodsnps = {}
with open(goodsnppath) as file:
    for line in file:
        sline = line.rstrip('\n').split()
        snpindex = sline[0].strip('"')
        if notzero: snpindex = str(int(snpindex) - 1)
        if sline[1].strip('"') in goodvals:
            goodsnps[snpindex] = True
        else:
            goodsnps[snpindex] = False

with open(snptablepath) as file:
    for entry in enumerate(file):
        index = entry[0]
        line = entry[1].rstrip('\n')
        if index == 0 and header:
            print line
            continue
        if cols:
            snpindex = line.split()[snpindexcol]
        elif header:
            snpindex = str(index - 1)
        else:
            snpindex = str(index)
        try:
            if goodsnps[snpindex]:
                print line
        except KeyError:
            sys.stderr.write("index " + str(snpindex) + " not in good_snps; censoring.")

