#!/usr/bin/env python3

import sys
from scipy.stats import combine_pvalues
from collections import deque

def window_combine(datadeque, column, winstart, winend, winchrom):
    pvals = [float(x[column]) for x in datadeque]
    try:
        chisq, combined_pval = combine_pvalues(pvals)
    except:
        chisq, combined_pval = "NA", "NA"
    if winchrom != None:
        if len(datadeque) > 0:
            #print("\t".join(map(str, datadeque[int(len(datadeque)/2)] + [chisq, combined_pval])))
            #print("\t".join(map(str, [winchrom, str(winstart) + "_" + str(winend), chisq, combined_pval])))
            print("\t".join(map(str, [winchrom, str((winstart + winend) / 2), 0.0, chisq, combined_pval])))
        else:
            print("NA\tNA")
    
def flush_data(winchrom, winstart, winend, datadeque, chromcol, bpcol, column):
    while len(datadeque) > 0:
        if not (datadeque[0][chromcol] != winchrom or int(datadeque[0][bpcol]) < winstart):
            break
        datadeque.popleft()
    window_combine(datadeque, column, winstart, winend, winchrom)

def sliding_window_bp_combine(inconn, column, chromcol, bpcol, winsize, winstep):
    datadeque = deque()
    winchrom = None
    winstart = 0
    winend = winsize
    for l in sys.stdin:
        sl = l.rstrip('\n').split('\t')
        chrom = sl[chromcol]
        bp = int(sl[bpcol])
        if chrom != winchrom or bp >= winend:
            flush_data(winchrom, winstart, winend, datadeque, chromcol, bpcol, column)
            if chrom != winchrom:
                winstart = 0
            else:
                winstart += winstep
            winchrom = chrom
            winend = winstart + winsize
        datadeque.append(sl)
    flush_data(winchrom, winstart, winend, datadeque, chromcol, bpcol, column)
        
def main():
    sliding_window_bp_combine(sys.stdin, int(sys.argv[1]), int(sys.argv[2]), int(sys.argv[3]), int(sys.argv[4]), int(sys.argv[5]))

if __name__ == "__main__":
    main()
