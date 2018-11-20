#!/usr/bin/env python
import argparse
import math

from itertools import count, tee, izip, islice

def get_thresh(dataset,alpha,gsize,mtc_method):
    if mtc_method == "bonferroni":
        return get_thresh_bonferroni(dataset,alpha,gsize)
    elif mtc_method == "grouping":
        return get_thresh_grouping(dataset,alpha,gsize)
    else:
        exit("multiple testing correction option not available!\n")

def get_thresh_bonferroni(dataset,alpha,gsize):
    if not smaller:
        dataset = sorted(dataset,reverse=True)
    else:
        dataset = sorted(dataset)
    if not window:
        coralpha = alpha / gsize
    else:
        #coralpha = alpha / math.ceil(gsize / float(winstep))
        coralpha = alpha / gsize
    element_index = int(math.ceil(len(dataset) * coralpha))
    thresh = dataset[element_index]
    return thresh

def get_thresh_grouping(dataset,alpha,gsize):
    #work in progress
    return None

def mean(x):
    return sum(x)/float(len(x))

def slidemean(x,winsize,winstep):
    return [ mean(x[i:i+winsize]) for i in range(0, len(x), winstep) if i+winsize <= len(x) ]

def get_windat(data,winsize,winstep):
    outlist = []
    for dataset in data:
        outlist.append(slidemean(dataset,winsize,winstep))
    return outlist

if __name__ == "__main__":

    parser = argparse.ArgumentParser(description="generate a genome-wide significance threshold from a set of simulated values in a distribution")
    parser.add_argument("simdata",help="path to a file containing simulated data in the Bayenv output format.  One significance threshold per column.")
    parser.add_argument("-t","--thresh",help="genome-wide significance threshold required (default = 0.05)")
    parser.add_argument("-g","--genome_size",help="number of data points in genome (default = 1)")
    parser.add_argument("-c","--cols",help="columns to analyze (separated by commas); default is all but '0'")
    parser.add_argument("-m","--multiple_correction",help="method to use for multiple testing correction. Accepted inputs are 'bonferroni' and 'grouping' (default is 'bonferroni').")
    parser.add_argument("-s","--smaller",help="determines whether significant hits should be larger or smaller than the threshold value (default is larger)",action="store_true")
    parser.add_argument("-w","--window_average",help="set a number of data points to average to compute thresholds for sliding window averages (default = no window)")
    parser.add_argument("-p","--window_step",help="set the step distance for the sliding window average (default = window_average)")
    parser.add_argument("-i","--include_first_col",help="include first column in list of columns to calculate threshold for. Overridden by -c. (default = False)",action = "store_true")
    
    args = parser.parse_args()
    if args.thresh:
        alpha = float(args.thresh)
    else:
        alpha = 0.05
    if args.genome_size:
        gsize = float(args.genome_size)
    else:
        gsize = 1
    if args.cols:
        cols = map(int,args.cols.split(","))
    elif args.include_first_col:
        cols = "all_plus_first"
    else:
        cols = "all"
    inpath = args.simdata
    if args.multiple_correction:
        mtc_method = args.multiple_correction
    else:
        mtc_method = "bonferroni"
    smaller = True if args.smaller else False
    if args.window_average:
        window=True
        winsize=int(args.window_average)
    else:
        window=False
        winsize=1
    if args.window_step:
        winstep=int(args.window_step)
    else:
        winstep=winsize
    
    
    for entry in enumerate(open(inpath,"r")):
        index = entry[0]
        sline = entry[1].rstrip('\n').split()
        if index == 0:
            if cols == "all":
                cols = range(1,len(sline))
            elif cols == "all_plus_first":
                cols = range(0,len(sline))
            data = [[] for x in cols]
        mydat = [float(sline[x]) for x in cols]
        for i in xrange(len(mydat)):
            data[i].append(mydat[i])
    
    outlist = []
    
    #for dataset in data:
    #    dataset.sort()
    if not window:
        for dataset in data:
            outlist.append(get_thresh(dataset,alpha,gsize,mtc_method))
    
    else:
        windat = get_windat(data,winsize,winstep)
        for dataset in windat:
            outlist.append(get_thresh(dataset,alpha,gsize,mtc_method))
    
    print "\t".join(map(str,outlist))

