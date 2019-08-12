#!/usr/bin/env python3

import sys
import tempfile
import statistics

class Cpos_data(object):
    def __init__(self):
        self.freqs = []
        self.counts = []
        self.freqs_mean = None
        self.freqs_sd = None
        self.counts_mean = None
        self.counts_sd = None


def read_table():
    data = {}
    atemp = tempfile.TemporaryFile(mode="w+")
    for i, l in enumerate(sys.stdin):
        if i==0:
            print(l.rstrip('\n') + "\tfreq_mean\tfreq_sd\tcount_mean\tcount_sd")
            continue
        sl = l.rstrip('\n').split('\t')
        cpos = (sl[0], sl[1])
        hits = float(sl[-3])
        count = float(sl[-1])
        if count > 0:
            freq = hits / count
        else:
            freq = float('nan')
        if not cpos in data:
            data[cpos] = Cpos_data()
        data[cpos].freqs.append(freq)
        data[cpos].counts.append(count)
        atemp.write(l)
    return(data, atemp)

def calculate_means(data):
    for cpos, cpos_data in data.items():
        cpos_data.freqs_mean = statistics.mean(cpos_data.freqs)
        cpos_data.freqs_sd = statistics.stdev(cpos_data.freqs)
        cpos_data.counts_mean = statistics.mean(cpos_data.counts)
        cpos_data.counts_sd = statistics.stdev(cpos_data.counts)

def write_data(data, atemp):
    atemp.seek(0)
    for l in atemp:
        sl = l.rstrip('\n').split('\t')
        cpos = (sl[0], sl[1])
        cpos_data = data[cpos]
        sl.append(cpos_data.freqs_mean)
        sl.append(cpos_data.freqs_sd)
        sl.append(cpos_data.counts_mean)
        sl.append(cpos_data.counts_sd)
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
