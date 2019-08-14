#!/usr/bin/env python3

import sys
import tempfile
import statistics
#import numpy as np
import math

class Cpos_data(object):
    def __init__(self):
        self.freqs_mean = None
        self.freqs_sd = None
        self.counts_mean = None
        self.counts_sd = None
        self.freqsum = 0
        self.freqsum_sq = 0
        self.freqn = 0
        self.countsum = 0
        self.countsum_sq = 0
        self.countn = 0
        
        self.freqs_mean_het = None
        self.freqs_sd_het = None
        self.counts_mean_het = None
        self.counts_sd_het = None
        self.freqsum_het = 0
        self.freqsum_sq_het = 0
        self.freqn_het = 0
        self.countsum_het = 0
        self.countsum_sq_het = 0
        self.countn_het = 0
        
        self.freqs_mean_blood = None
        self.freqs_sd_blood = None
        self.counts_mean_blood = None
        self.counts_sd_blood = None
        self.freqsum_blood = 0
        self.freqsum_sq_blood = 0
        self.freqn_blood = 0
        self.countsum_blood = 0
        self.countsum_sq_blood = 0
        self.countn_blood = 0
        
        self.freqs_mean_het_blood = None
        self.freqs_sd_het_blood = None
        self.counts_mean_het_blood = None
        self.counts_sd_het_blood = None
        self.freqsum_het_blood = 0
        self.freqsum_sq_het_blood = 0
        self.freqn_het_blood = 0
        self.countsum_het_blood = 0
        self.countsum_sq_het_blood = 0
        self.countn_het_blood = 0
    def printme(self):
        print(self.freqsum, self.freqsum_sq, self.freqn, self.countsum, self.countsum_sq, self.countn, self.freqs_mean, self.freqs_sd, self.counts_mean, self.counts_sd, sep="\n")
        print("<======>")
    def update_freqs(self, freq):
        if not freq == "NA":
            self.freqsum += freq
            self.freqsum_sq += (freq * freq)
            self.freqn += 1
    def update_freqs_het(self, freq):
        if not freq == "NA":
            self.freqsum_het += freq
            self.freqsum_sq_het += (freq * freq)
            self.freqn_het += 1
    def update_counts(self, count):
        if not count == "NA":
            self.countsum += count
            self.countsum_sq += (count * count)
            self.countn += 1
    def update_counts_het(self, count):
        if not count == "NA":
            self.countsum_het += count
            self.countsum_sq_het += (count * count)
            self.countn_het += 1
    def update_freqs_blood(self, freq):
        if not freq == "NA":
            self.freqsum_blood += freq
            self.freqsum_sq_blood += (freq * freq)
            self.freqn_blood += 1
    def update_freqs_het_blood(self, freq):
        if not freq == "NA":
            self.freqsum_het_blood += freq
            self.freqsum_sq_het_blood += (freq * freq)
            self.freqn_het_blood += 1
    def update_counts_blood(self, count):
        if not count == "NA":
            self.countsum_blood += count
            self.countsum_sq_blood += (count * count)
            self.countn_blood += 1
    def update_counts_het_blood(self, count):
        if not count == "NA":
            self.countsum_het_blood += count
            self.countsum_sq_het_blood += (count * count)
            self.countn_het_blood += 1
    def mean_sd(self):
        self.freqs_mean = meanit(self.freqsum, self.freqn)
        self.freqs_sd = sdit(self.freqsum, self.freqsum_sq, self.freqn)
        self.counts_mean = meanit(self.countsum, self.countn)
        self.counts_sd = sdit(self.countsum, self.countsum_sq, self.countn)
        self.freqs_mean_het = meanit(self.freqsum_het, self.freqn_het)
        self.freqs_sd_het = sdit(self.freqsum_het, self.freqsum_sq_het, self.freqn_het)
        self.counts_mean_het = meanit(self.countsum_het, self.countn_het)
        self.counts_sd_het = sdit(self.countsum_het, self.countsum_sq_het, self.countn_het)
        
        self.freqs_mean_blood = meanit(self.freqsum_blood, self.freqn_blood)
        self.freqs_sd_blood = sdit(self.freqsum_blood, self.freqsum_sq_blood, self.freqn_blood)
        self.counts_mean_blood = meanit(self.countsum_blood, self.countn_blood)
        self.counts_sd_blood = sdit(self.countsum_blood, self.countsum_sq_blood, self.countn_blood)
        self.freqs_mean_het_blood = meanit(self.freqsum_het_blood, self.freqn_het_blood)
        self.freqs_sd_het_blood = sdit(self.freqsum_het_blood, self.freqsum_sq_het_blood, self.freqn_het_blood)
        self.counts_mean_het_blood = meanit(self.countsum_het_blood, self.countn_het_blood)
        self.counts_sd_het_blood = sdit(self.countsum_het_blood, self.countsum_sq_het_blood, self.countn_het_blood)

def meanit(asum, n):
    out = "NA"
    if n>=1:
        out = asum / n
    return(out)

def sdit(asum, asum_sq, n):
    out = "NA"
    try:
        if n>= 2:
            out = math.sqrt( ((n * asum_sq) - (asum * asum)) / (n * (n-1)) )
    except ValueError:
        pass
    return(out)

def normalize(x, mean, sd):
    out = "NA"
    try:
        if sd > 0:
            out = (x-mean) / sd
    except TypeError:
        pass
    return(out)

def read_table():
    data = {}
    atemp = tempfile.TemporaryFile(mode="w+")
    for i, l in enumerate(sys.stdin):
        if i==0:
            print(l.rstrip('\n') + "\tfreq_mean\tfreq_sd\tcount_mean\tcount_sd\tfreq_mean_het\tfreq_sd_het\tcount_mean_het\tcount_sd_het\tfreq_mean_blood\tfreq_sd_blood\tcount_mean_blood\tcount_sd_blood\tfreq_mean_het_blood\tfreq_sd_het_blood\tcount_mean_het_blood\tcount_sd_het_blood\thet\tfreq\tfreq_nor\tfreq_nor_het\tcount_nor\tcount_nor_het\tfreq_nor_blood\tfreq_nor_het_blood\tcount_nor_blood\tcount_nor_het_blood")
            continue
        sl = l.rstrip('\n').split('\t')
        cpos = (sl[0], sl[1])
        hits = float(sl[-3])
        count = float(sl[-1])
        gt = sl[-4]
        het = False
        if len(gt) >= 3:
            if not gt[0] == gt[-1]:
                het = True
        blood = False
        if sl[5] == "Blood":
            blood = True
        if count > 0:
            freq = hits / count
        else:
            freq = "NA"
        if not cpos in data:
            data[cpos] = Cpos_data()
        data[cpos].update_freqs(freq)
        data[cpos].update_counts(count)
        if het:
            data[cpos].update_freqs_het(freq)
            data[cpos].update_counts_het(count)
        if blood:
            data[cpos].update_freqs_blood(freq)
            data[cpos].update_counts_blood(count)
            if het:
                data[cpos].update_freqs_het_blood(freq)
                data[cpos].update_counts_het_blood(count)
        atemp.write(l)
    return(data, atemp)

def calculate_means(data):
    for cpos, cpos_data in data.items():
        cpos_data.mean_sd()

def write_data(data, atemp):
    atemp.seek(0)
    for l in atemp:
        sl = l.rstrip('\n').split('\t')
        cpos = (sl[0], sl[1])
        cpos_data = data[cpos]
        hits = float(sl[-3])
        count = float(sl[-1])
        gt = sl[-4]
        het = False
        if len(gt) >= 3:
            if not gt[0] == gt[-1]:
                het = True
        if het:
            hetp = "TRUE"
        else:
            hetp = "FALSE"
        if count > 0:
            freq = hits / count
        else:
            freq = "NA"
        
        freq_nor = normalize(freq, cpos_data.freqs_mean, cpos_data.freqs_sd)
        freq_nor_het = normalize(freq, cpos_data.freqs_mean_het, cpos_data.freqs_sd_het)
        count_nor = normalize(count, cpos_data.counts_mean, cpos_data.counts_sd)
        count_nor_het = normalize(count, cpos_data.counts_mean_het, cpos_data.counts_sd_het)
        
        freq_nor_blood = normalize(freq, cpos_data.freqs_mean_blood, cpos_data.freqs_sd_blood)
        freq_nor_het_blood = normalize(freq, cpos_data.freqs_mean_het_blood, cpos_data.freqs_sd_het_blood)
        count_nor_blood = normalize(count, cpos_data.counts_mean_blood, cpos_data.counts_sd_blood)
        count_nor_het_blood = normalize(count, cpos_data.counts_mean_het_blood, cpos_data.counts_sd_het_blood)
        sl.append(cpos_data.freqs_mean)
        sl.append(cpos_data.freqs_sd)
        sl.append(cpos_data.counts_mean)
        sl.append(cpos_data.counts_sd)
        sl.append(cpos_data.freqs_mean_het)
        sl.append(cpos_data.freqs_sd_het)
        sl.append(cpos_data.counts_mean_het)
        sl.append(cpos_data.counts_sd_het)
        
        sl.append(cpos_data.freqs_mean_blood)
        sl.append(cpos_data.freqs_sd_blood)
        sl.append(cpos_data.counts_mean_blood)
        sl.append(cpos_data.counts_sd_blood)
        sl.append(cpos_data.freqs_mean_het_blood)
        sl.append(cpos_data.freqs_sd_het_blood)
        sl.append(cpos_data.counts_mean_het_blood)
        sl.append(cpos_data.counts_sd_het_blood)
        
        sl.append(hetp)
        sl.append(freq)
        sl.append(freq_nor)
        sl.append(freq_nor_het)
        sl.append(count_nor)
        sl.append(count_nor_het)
        sl.append(freq_nor_blood)
        sl.append(freq_nor_het_blood)
        sl.append(count_nor_blood)
        sl.append(count_nor_het_blood)
        print("\t".join(map(str, sl)))
    atemp.close()

def main():
    data, atemp = read_table()
    calculate_means(data)
    write_data(data, atemp)

if __name__ == "__main__":
    main()

#X	101	0.4	A	C	Blood	NA00001	0	100	5	105
#X	102	0.4	A	G	Blood	NA00001	0	108	5	113
#X	103	0.4	GT	TAT	Blood	NA00001	0	80	5	85
#X	101	0.4	A	C	Blood	NA00002	0/1	50	45	95
#X	102	0.4	A	G	Blood	NA00002	0/1	50	45	95
#X	103	0.4	GT	TAT	Blood	NA00002	0/1	50	45	95
#X	101	0.4	A	C	Sperm	NA00003	0|1	10	108	118
#X	102	0.4	A	G	Sperm	NA00003	0|1	10	108	118
#X	103	0.4	GT	TAT	Sperm	NA00003	0|1	10	108	118
#X	101	0.4	A	C	Sperm	NA00004	0|1	55	45	100
#X	102	0.4	A	G	Sperm	NA00004	0|1	55	45	100
#X	103	0.4	GT	TAT	Sperm	NA00004	0|1	55	45	100
