#!/usr/bin/python

from operator import itemgetter
import gzip

#set these before beginning:
inpaths_path = "inpaths.txt"
skip_ql_generation = True
ql_list_inpath = "quality_and_length_list_pero_1-18.txt"
final_outpath = "pero_pacbio_ds_85qual_2klen.fq.gz"
target_prob_out = "target_prob_100x.txt"
target_prob = 0.85
target_rlen = 2000

def mean(l):
    return float(sum(l))/len(l) if len(l) > 0 else float('nan')

def get_probmean(s):
    problist = []
    for j in s:
        phredscore = ord(j) - 33
        probgood = 1 - (float(10) ** (-float(phredscore)/float(10)))
        problist.append(probgood)
    return mean(problist)

inpaths = [line.rstrip('\n') for line in open(inpaths_path)]


if not skip_ql_generation:
    ql_list = []
    
    for path in inpaths:
        with gzip.open(path,"r") as file:
            i = 0
            for line in file:
                if i%4 == 3:
                    line = line.rstrip('\n')
                    length = len(line)
                    probmean = get_probmean(line)
                    ql_list.append([length,probmean])
                    #print line
                    #print length
                    #print probmean
                i += 1
    
    with open(ql_list_outpath,"w") as outfile:
        for entry in ql_list:
            outfile.write("\t".join(map(str,entry)))
            outfile.write("\n")
            #print "\t".join(map(str,entry))
else:
    ql_list = []
    with open(ql_list_inpath,"r") as infile:
        for line in infile:
            lines = line.rstrip('\n').split()
            length = int(lines[0])
            probmean = float(lines[1])
            ql_list.append([length,probmean])

ql_list_sorted = sorted(ql_list, key=itemgetter(1,0), reverse=True)

#with open(ql_list_sorted_outpath,"w") as outfile:
#    for entry in ql_list_sorted:
#        outfile.write("\t".join(map(str,entry)))
#        outfile.write("\n")
#        #print "\t".join(map(str,entry))
#
#lensum = 0
#pos = 0
#ql_list_sorted_length = len(ql_list_sorted)
#while lensum < target_length and pos < ql_list_sorted_length:
#        lensum += ql_list_sorted[pos][0]
#        target_prob = ql_list_sorted[pos][1]
#        pos += 1
#
#with open(target_prob_out,"w") as outfile:
#    outfile.write(str(target_prob)+"\n")

with gzip.open(final_outpath,"w") as outfile:
    ql_index = 0
    for path in inpaths:
        with gzip.open(path,"r") as file:
            i = 0
            for line in file:
                line = line.rstrip('\n')
                if i%4 == 0: header = line
                if i%4 == 1: seq = line
                if i%4 == 2: plus = line
                if i%4 == 3:
                    quals = line
                    probmean = ql_list[ql_index][1]
                    mylen = ql_list[ql_index][0]
                    if probmean >= target_prob:
                        outfile.write(header + "\n")
                        outfile.write(seq + "\n")
                        outfile.write(plus + "\n")
                        outfile.write(quals + "\n")
                    ql_index += 1
                i += 1

