import sys
from scipy.stats.stats import pearsonr
from math import floor

#usage: python correlate_window_all.py /path/to/data /path/to/header window_size window_step > out

#inpath = str(sys.argv[1])
#headerpath = str(sys.argv[2])
window_size = int(sys.argv[1])
window_step = int(sys.argv[2])

#maleperc = [0.290,0.184,0.200,0.225,0.208,0.208,.248,0.221,0.325,0.168,0.231]

def mean(alist):
    #note: list must be all ints or floats
    sum = float(0)
    for entry in alist:
        sum += entry
    mymean = sum / float(len(alist))
    return mymean

#headers = [line.rstrip('\n') for line in open(headerpath)]
mainqueue=[]
valqueue=[]
current_header = ""
chrompos = 1
current_chrom = int()
covqueue = []
#num_pops = len(maleperc)

#temp = window_size + 5
#malepercfulltemp = [maleperc for y in [None]*temp]
#malepercfull=[item for sublist in malepercfulltemp for item in sublist]

#print " ".join(map(str,malepercfull[:24]))
#print len(malepercfull)

#def window_correlation(mainqueue,covqueue):
#    midpos = mainqueue[-1][2] - floor(float(len(mainqueue) / 2.0))
#    malepercqueue = malepercfull[0:len(covqueue)]
#    #print " ".join(map(str,covqueue[:24]))
#    #print len(covqueue)
#    #print " ".join(map(str,malepercqueue[:24]))
#    #print len(malepercqueue)
#    cor = list(pearsonr(covqueue,malepercqueue))
#    header = mainqueue[0][0]
#    out = [header,midpos]+cor
#    return(out)

for line in sys.stdin:
    sline = line.rstrip('\n').split()
    index = int(sline[0])
    batch = sline[1]
    value = float(sline[2])
    chrom = sline[3]
    try:
        chrompos_bp = int(sline[4])
    except ValueError:
        chrompos_bp = 0
    #covs = map(int,covs)
    if len(mainqueue) <= window_size and chrom == current_header:
        #simply add to queue and increment chrompos
        mainqueue.append([index,batch,value,chrom,chrompos_bp])
        chrompos += 1
        valqueue.append(value)
    elif chrom != current_header:
        #do correlation, change current header, reset chrompos, and fully erase queue
        if len(mainqueue) > 0 and len(valqueue) > 0:
            mymean = mean(valqueue)
            print "\t".join(map(str,[index,batch,value,chrom,chrompos_bp,mymean]))
        current_header = chrom
        chrompos = 0
        mainqueue = [[index,batch,value,chrom,chrompos_bp]]
        valqueue = [value]
    else:
        #do correlation, remove window_size from front of queue, increment chrompos
        if len(mainqueue) > 0 and len(valqueue) > 0:
            mymean = mean(valqueue)
            print "\t".join(map(str,[index,batch,value,chrom,chrompos_bp,mymean]))
        mainqueue.append([index,batch,value,chrom,chrompos_bp])
        mainqueue = mainqueue[window_step:]
        valqueue = valqueue[window_step:]
        chrompos += 1

