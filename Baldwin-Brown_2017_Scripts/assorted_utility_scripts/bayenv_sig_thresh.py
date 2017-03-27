import argparse
import math

parser = argparse.ArgumentParser(description="generate a genome-wide significance threshold from a set of simulated values in a distribution")
parser.add_argument("simdata",help="path to a file containing simulated data in the Bayenv output format.  One significance threshold per column.")
parser.add_argument("-t","--thresh",help="genome-wide significance threshold required (default = 0.05)")
parser.add_argument("-g","--genome_size",help="number of data points in genome (default = 1)")
parser.add_argument("-c","--cols",help="columns to analyze (separated by commas); default is all but '0'")
parser.add_argument("-m","--multiple_correction",help="method to use for multiple testing correction. Accepted inputs are 'bonferroni' and 'grouping' (default is 'bonferroni').")
parser.add_argument("-w","--window_length",help="number of adjacent snps to average together to simulate sliding window results")

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
else:
    cols = "all"
inpath = args.simdata
if args.multiple_correction:
    mtc_method = args.multiple_correction
else:
    mtc_method = "bonferroni"
if args.window_length:
    wlen = int(args.window_length)
else:
    wlen = False

def get_thresh(dataset,alpha,gsize,mtc_method):
    if mtc_method == "bonferroni":
        return get_thresh_bonferroni(dataset,alpha,gsize)
    elif mtc_method == "grouping":
        return get_thresh_grouping(dataset,alpha,gsize)
    else:
        exit("multiple testing correction option not available!\n")

def get_thresh_bonferroni(dataset,alpha,gsize):
    dataset = sorted(dataset,reverse=True)
    coralpha = alpha / gsize
    if not wlen:
        element_index = int(math.ceil(len(dataset) * coralpha))
        thresh = dataset[element_index]
    else:
        avgdat = [mean(x) for x in chunks(dataset,wlen)]
        element_index = int(math.ceil(len(avgdat) * coralpha))
        thresh = dataset[element_index]
    return thresh

def get_thresh_grouping(dataset,alpha,gsize):
    #work in progress
    return None

def chunks(l, n):
    """Yield successive n-sized chunks from l."""
    for i in range(0, len(l), n):
        yield l[i:i + n]

def mean(numbers):
    return float(sum(numbers)) / max(len(numbers), 1)

for entry in enumerate(open(inpath,"r")):
    index = entry[0]
    sline = entry[1].rstrip('\n').split()
    if index == 0:
        if cols == "all":
            cols = range(1,len(sline))
        data = [[] for x in cols]
    mydat = [float(sline[x]) for x in cols]
    for i in xrange(len(mydat)):
        data[i].append(mydat[i])

outlist = []

#for dataset in data:
#    dataset.sort()
for dataset in data:
    outlist.append(get_thresh(dataset,alpha,gsize,mtc_method))

print "\t".join(map(str,outlist))

