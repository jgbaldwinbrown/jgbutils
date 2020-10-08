#!/usr/bin/env python3

#import scipy
from scipy.signal import find_peaks_cwt
import sys
import argparse

def readfasta(inconn):
    header = ""
    seq = ""
    out = []
    for l in inconn:
        l=l.rstrip('\n')
        if l[0] == ">":
            if len(header) > 0 and len(seq) > 0:
                out.append((header, seq))
            header = l
            seq = ""
        else:
            seq = seq + l
    if len(header) > 0 and len(seq) > 0:
        out.append((header, seq))
    return out

def readfastas(inconn):
    fastas = []
    fatitle = ""
    fabuffer = []
    for l in inconn:
        l=l.rstrip('\n')
        #print("l: ",l)
        if l[0] == ">" and not fatitle == l.split(':')[0]:
            #print("fatitle: ",fatitle)
            if len(fatitle) > 0:
                #print("fabuffer: ", fabuffer)
                fastas.append(readfasta(fabuffer))
            fatitle = l.split(':')[0]
            fabuffer = [l]
        else:
            fabuffer.append(l)
    if len(fatitle) > 0:
        fastas.append(readfasta(fabuffer))
    return(fastas)

def getlens(fadat):
    out = []
    for i in fadat:
        out.append(len(i[1]))
    return(out)

def gethist(falens):
    out = []
    mymin = min(falens)
    mymax = max(falens)
    for i in range(mymin,mymax+1):
        out.append((i, falens.count(i)))
    return(out)

def getpeaks(hist, max_width, min_width):
    histcounts = [x[1] for x in hist]
    if not max_width:
        mymax = 1000
    else:
        mymax = max_width
    if not min_width:
        mymin = 1
    else:
        mymin = min_width
    if len(histcounts) > 0 and mymin and mymax:
        out = find_peaks_cwt(histcounts, [x for x in range(mymin,mymax+1)])
    else:
        out = array([], dtype=float64)
    return(out)

def getfasta(peaks, hist, fadat):
    out = []
    histlens = [x[0] for x in hist]
    peaklens = [histlens[x] for x in peaks]
    for i in fadat:
        if len(i[1]) in peaklens:
            out.append(i)
    return(out)

def writefasta(fasta):
    for i in fasta:
        print(i[0])
        print(i[1])

if __name__ == "__main__":

    parser = argparse.ArgumentParser(description = "Identify the reads that best represent each transcript in a cluster.")
    parser.add_argument("infasta", help="The input fasta in which to identify transcripts.")
    parser.add_argument("-w", "--max_width", help="The largest acceptable peak width.")
    parser.add_argument("-m", "--min_width", help="The smallest acceptable peak width.")
    parser.add_argument("-l", "--min_length", help="The smallest acceptable read length.")
    parser.add_argument("-t", "--min_transcripts", help="Minimum number of transcripts that must be taken per cluster.")

    args = parser.parse_args()

    if args.infasta == "-":
        inconn = sys.stdin
    else:
        inconn = open(args.infasta,"r")

    min_length = None
    min_width = None
    max_width = None
    min_tran = None
    if args.max_width:
        max_width = int(args.max_width)
    if args.min_width:
        min_width = int(args.min_width)
    if args.min_length:
        min_length = int(args.min_length)
    if args.min_transcripts:
        min_tran = int(args.min_transcripts)

    fadats = readfastas(inconn)
    #fadat = readfasta(inconn)
    for fadat in fadats:
        if min_tran and len(fadat) <= min_tran:
            peakfasta = fadat
        else:
            falens = getlens(fadat)
            hist = gethist(falens)
            peaks = getpeaks(hist, max_width, min_width)
            peakfasta = getfasta(peaks, hist, fadat)
            if min_length:
                peakfasta = [x for x in peakfasta if len(x[1]) >= min_length]
        writefasta(peakfasta)

    inconn.close()

