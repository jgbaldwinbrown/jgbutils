import sys
#from scipy.stats.stats import pearsonr
from math import floor

#usage: python correlate_window_all.py /path/to/data /path/to/header window_size window_step > out

window_size = int(sys.argv[1])
window_step = int(sys.argv[2])
window_col = int(sys.argv[3])
chrom_col = int(sys.argv[4])
header = sys.argv[5]

def mean(alist):
    #note: list must be all ints or floats
    sum = float(0)
    for entry in alist:
        sum += entry
    mymean = sum / float(len(alist))
    return mymean

mainqueue=[]
xtxqueue=[]
current_header = ""
current_chrom = int()

for entry in enumerate(sys.stdin):
    loopindex = entry[0]
    line = entry[1]
    if loopindex == 0:
        print line.rstrip('\n') + "\tbf"+str(window_col)+"_win" + str(window_size)
        continue
    sline = line.rstrip('\n').split()
    chrom = sline[chrom_col]
    xtx = float(sline[window_col])
    if len(mainqueue) <= window_size and chrom == current_header:
        #simply add to queue and increment chrompos
        mainqueue.append([chrom,xtx])
        xtxqueue.append(xtx)
    elif chrom != current_header:
        #do correlation, change current header, reset chrompos, and fully erase queue
        if len(mainqueue) > 0 and len(xtxqueue) > 0:
            myxtxmean = mean(xtxqueue)
            outline = sline
            outline.extend([myxtxmean])
            print "\t".join(map(str,outline))
        current_header = chrom
        mainqueue = [[chrom,xtx]]
        xtxqueue = [xtx]
    else:
        #do correlation, remove window_size from front of queue, increment chrompos
        if len(mainqueue) > 0 and len(xtxqueue) > 0:
            myxtxmean = mean(xtxqueue)
            outline = sline
            outline.extend([myxtxmean])
            print "\t".join(map(str,outline))
        mainqueue.append([chrom,xtx])
        mainqueue = mainqueue[window_step:]
        xtxqueue.append(xtx)
        xtxqueue = xtxqueue[window_step:]

