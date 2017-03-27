#!/usr/bin/env python

import numpy
import itertools

def calc_af_diff(freqs1,freqs2):
    if len(freqs1) != len(freqs2):
        exit("number of frequencies must match!")
    outlist=[]
    for f1,f2 in itertools.izip(freqs1,freqs2):
        #print "f=" + f
        #print "c=" + c
        try:
            f1=float(f1)
            f2=float(f2)
        except ValueError:
            outlist.append("NA")
            continue
        fd = f1-f2
        outlist.append(fd)
    return outlist

def calc_af_diff_file(infile,infreq1,infreq2,hasheader):
    freqs1=[]
    freqs2=[]
    with open(infile,"r") as file:
        for entry in enumerate(file):
            index=entry[0]
            line=entry[1]
            if hasheader and index==0:
                continue
            sline = line.rstrip('\n').split()
            f1=sline[infreq1]
            f2=sline[infreq2]
            freqs1.append(f1)
            freqs2.append(f2)
    return calc_af_diff(freqs1,freqs2)

def main():
    import sys
    
    args=sys.argv
    infile=str(args[1])
    infreq1=int(args[2])
    infreq2=int(args[3])
    hasheader= True if args[4] == "True" else False
    
    out = calc_af_diff_file(infile,infreq1,infreq2,hasheader)
    for i in out:
        print str(i)

if __name__ == "__main__":
    main()
