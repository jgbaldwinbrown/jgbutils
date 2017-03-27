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

def mean(data):
    """Return the sample arithmetic mean of data."""
    n = len(data)
    if n < 1:
        raise ValueError('mean requires at least one data point')
    #return sum(data)/n # in Python 2 use sum(data)/float(n)
    return sum(data)/float(n)

def _ss(data):
    """Return sum of square deviations of sequence data."""
    c = mean(data)
    ss = sum((x-c)**2 for x in data)
    return ss

def pstdev(data):
    """Calculates the population standard deviation."""
    n = len(data)
    if n < 2:
        raise ValueError('variance requires at least two data points')
    ss = _ss(data)
    #pvar = ss/n # the population variance
    pvar = ss/float(n)
    return pvar**0.5

def try_revert_na(func,dat):
    if dat == "NA":
        return dat
    else:
        return func(dat)
    #try:
    #    out = func(dat)
    #except ValueError,TypeError:
    #    out = "NA"
    #return out

def try_float_na(dat):
    return try_revert_na(float,dat)

parser = argparse.ArgumentParser(description = 'convert select columns to the log of the current values')
parser.add_argument("infile",help="path to the table of interest")
parser.add_argument("-o","--outpath",help="path to write output (default = stdout)")
parser.add_argument("-s","--skip_rows",help="comma separated list of rows to avoid logging (default = none)")
parser.add_argument("-c","--cols",help="comma separated list of columns to log (default = all)")
parser.add_argument("-m","--mean",help="subtract through the mean (default = False)",action="store_true")
parser.add_argument("-d","--stdev",help="divide by the standard deviation. Automatically switches on subtraction of mean. (default = False)",action="store_true")
parser.add_argument("-a","--abso",help="convert values to absolute values? (default = False)",action="store_true")
parser.add_argument("-r","--root",help="a column to keep always positive, switching others to positive or negative as necessary to maintain the correct relationship (default = none)")

args=parser.parse_args()
if args.skip_rows:
    rskips = map(int,args.skip_rows.split(","))
if args.cols:
    cols = map(int,args.cols.split(","))
if args.outpath:
    opath = args.outpath
else:
    opath = "-"

with smart_open(opath) as ofile:
    for e in enumerate(open(args.infile,"r")):
        row_bad = False
        i=e[0]
        l=e[1].rstrip('\n')
        if i == 0 and not args.cols:
            cols = range(len(l.split()))
        if i in rskips:
            ofile.write(l+"\n")
            continue
        sl = l.split()
        slout = sl
        mydats = map(try_float_na,[sl[x] for x in cols])
        myndats = []
        for di in mydats:
            if not di == "NA":
                myndats.append(di)
        #print myndats
        myouts = [x for x in mydats]
        if args.mean or args.stdev:
            if len(myndats) >= 1:
                lmean = mean(myndats)
            else:
                row_bad = True
            if args.stdev:
                if len(myndats) >= 2:
                    lstdev = pstdev(myndats)
                else:
                    row_bad = True
        for ce in enumerate(cols):
            ci=ce[0]
            c=ce[1]
            if not row_bad:
                if args.mean or args.stdev:
                    myouts[ci] = try_revert_na(lambda x: x - lmean, myouts[ci])
                if args.stdev:
                    myouts[ci] = try_revert_na(lambda x: x / lstdev, myouts[ci])
                if args.abso:
                    myouts[ci] = try_revert_na(lambda x: abs(x), myouts[ci])
            else:
                myouts[ci] = "NA"
            slout[c] = myouts[ci]
        ofile.write("\t".join(map(str,slout))+"\n")

