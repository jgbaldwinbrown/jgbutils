#!/usr/bin/python

from operator import itemgetter

#set these before beginning:
inpaths_path = "/dfs2/temp/bio/jbaldwi1/peromyscus_data/data/pacbio/all_files_v2_11-30-15.txt"
ql_list_outpath = "quality_and_length_list_pero_1-18.txt"
ql_list_sorted_outpath = "quality_and_length_sorted_list_pero_1-18.txt"
skip_ql_generation = False
ql_list_inpath = "quality_and_length_list_pero_1-18.txt"
final_outpath = "pero_pacbio_ds_by_quality_and_length.fq"
target_length = 7.8e10
target_prob_out = "target_prob_100x.txt"

def mean(l):
    return float(sum(l))/len(l) if len(l) > 0 else float('nan')

def get_probmean(s):
    problist = []
    for j in s:
        phredscore = ord(j) - 33
        probgood = 1 - (float(10) ** (-float(phredscore)/float(10)))
        problist.append(probgood)
    return mean(problist)

if not skip_ql_generation:
    ql_list = []
    
    inpaths = [line.rstrip('\n') for line in open(inpaths_path)]
    
    for path in inpaths:
        with open(path,"r") as file:
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

with open(ql_list_sorted_outpath,"w") as outfile:
    for entry in ql_list_sorted:
        outfile.write("\t".join(map(str,entry)))
        outfile.write("\n")
        print "\t".join(map(str,entry))

lensum = 0
pos = 0
ql_list_sorted_length = len(ql_list_sorted)
while lensum < target_length and pos < ql_list_sorted_length:
        lensum += ql_list_sorted[pos][0]
        target_prob = ql_list_sorted[pos][1]
        pos += 1

with open(target_prob_out,"w") as outfile:
    outfile.write(str(target_prob),"\n")

with open(final_outpath,"w") as outfile:
    ql_index = 0
    for path in inpaths:
        with open(path,"r") as file:
            i = 0
            for line in file:
                line = line.rstrip('\n')
                if i%4 == 0: header = line
                if i%4 == 1: seq = line
                if i%4 == 2: plus = line
                if i%4 == 3:
                    quals = line
                    probmean = ql_list[qlindex][1]
                    if probmean >= target_prob:
                        outfile.write(header + "\n")
                        outfile.write(seq + "\n")
                        outfile.write(plus + "\n")
                        outfile.write(quals + "\n")
                    qlindex += 1
                i += 1

#for all files in list:
#    for all lines in file:
#        print average quality of line and line length
#
#input qual/length list
#
#sort qual/length list (highest to lowest length, then highest to lowest quality)
#
#lensum = 0
#for line in ql_list:
#    if lensum < target_length
#    lensum += length in line
#    print line
#    
#done
#
#
#
#
#
#
#
##!/bin/python
#import sys
#from Bio import SeqIO
#import random
#from random import randrange
#import sys
#
##usage: python downsample_fq_v3.py [path_to_infile(fastq)] [fraction_of_data_to_keep] [path_to_outfile]
#
#cmd = sys.argv
#
#pbreads = str(cmd[1])
#keep = float(cmd[2])
#outpath = str(cmd[3])
#
#out = []
#unsorted_lengths = []
#lengths = []
#cumsum = []
#total_size = int()
#target = float()
#nx = int(0)
#
#for record in SeqIO.parse(pbreads,"fastq"):
#        unsorted_lengths.append(len(record))
#
#lengths = sorted(unsorted_lengths,reverse=True)
#cumsum.append(lengths[0])
#
#for i in range(1,len(lengths)):
#        cumsum.append(lengths[i]+cumsum[i-1])
#
#total_size = cumsum[-1]
#target = float(total_size) * float(keep)
#
#i = 0
#while (cumsum[i] < target):
#        i+=1
#i = i-1
#
#nx = lengths[i]
#
#i=0
#for record in SeqIO.parse(pbreads,"fastq"):
#        if unsorted_lengths[i] >= nx:
#                out.append(record)
#        i += 1
#
#SeqIO.write(out,outpath,"fastq")
