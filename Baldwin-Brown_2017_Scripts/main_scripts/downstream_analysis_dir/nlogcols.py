#!/usr/bin/env python
import sys
import argparse
import contextlib
import math

@contextlib.contextmanager
def smart_open(filename=None):
    if filename and filename != '-':
        fh = open(filename, 'w')
    else:
        fh = sys.stdout

    try:
        yield fh
    finally:
        if fh is not sys.stdout:
            fh.close()

parser = argparse.ArgumentParser(description = 'convert select columns to the log of the current values')
parser.add_argument("infile",help="path to the table of interest")
parser.add_argument("-o","--outpath",help="path to write output (default = stdout)")
parser.add_argument("-n","--negative",help="get negative version of current values (default = False)",action="store_true")
parser.add_argument("-b","--base",help="base to use for logarithm (default = 10)")
parser.add_argument("-s","--skip_rows",help="comma separated list of rows to avoid logging (default = none)")
parser.add_argument("-c","--cols",help="comma separated list of columns to log (default = all)")

args=parser.parse_args()
if args.base:
    base = float(args.base)
if args.skip_rows:
    rskips = map(int,args.skip_rows.split(","))
if args.cols:
    cols = map(int,args.cols.split(","))
if args.outpath:
    opath = args.outpath
else:
    opath = "-"
if args.negative:
    mult = -1
else:
    mult = 1

with smart_open(opath) as ofile:
    for e in enumerate(open(args.infile,"r")):
        i=e[0]
        l=e[1].rstrip('\n')
        if i == 0 and not args.cols:
            cols = range(len(l.split()))
        if i in rskips:
            ofile.write(l+"\n")
            continue
        sl = l.split()
        slout = sl
        for c in cols:
            slout[c] = math.log(float(sl[c]),base) * mult
        ofile.write("\t".join(map(str,slout))+"\n")

