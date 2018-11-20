#!/usr/bin/env python

import subprocess
import sys
import argparse

#Required:
#the 'nucmer','delta-filter', and 'merger' executables must be in the user's PATH

parser = argparse.ArgumentParser(description = 'Use quickmerge output and fasta files to annotate merge locations in merged sequences.')
parser.add_argument("-s","--sorted_merged_fasta", help="Path to sorted, renamed merged fasta")
parser.add_argument("-m","--merged_fasta", help="Path to original merged fasta")
parser.add_argument("-b","--bed_file", help="bed file to convert")

#parser.add_argument("hybrid_assembly_fasta", help="the output of a hybrid assembly program such as DBG2OLC")
#parser.add_argument("self_assembly_fasta",help="the output of a self assembly program such as PBcR")
#parser.add_argument("-pre","--prefix", help="the prefix for all output files")
#parser.add_argument("-hco","--hco", help="the quickmerge hco parameter (default=5.0)")
#parser.add_argument("-c","--c", help="the quickmerge c parameter (default=1.5)")
#parser.add_argument("-l","--length_cutoff", help="minimum seed contig length to be merged (default=0)")
#parser.add_argument("--no_nucmer", help="skip the nucmer step",action="store_true")
#parser.add_argument("--no_delta", help="skip the nucmer and delta-filter steps",action="store_true")
#parser.add_argument("--stop_after_nucmer", help="do not perform the delta-filter and merger steps",action="store_true")
#parser.add_argument("--stop_after_df", help="do not perform the merger step",action="store_true")
#parser.add_argument("-lm", "--length_minimum", help="set the minimum alignment length necessary for use in quickmerge (default 0)")
#parser.add_argument("--clean_only", help="generate safe FASTA files for merging, but do not merge",action="store_true")

args=parser.parse_args()
if not args.merged_fasta:
    exit("merged fasta is required!")
else:
    mfp = args.merged_fasta

if not args.sorted_merged_fasta:
    exit("sorted merged fasta is required!")
else:
    smfp = args.sorted_merged_fasta

if not args.bed_file:
    exit("bed file is required!")
else:
    bfp = args.bed_file

def parse_fasta(p):
    out=[]
    h=""
    lens=0
    record = 0
    for l in open(p,"r"):
        l=l.rstrip('\n')
        if l[0] == ">":
            if lens > 0 and len(h) > 0:
                out.append([h,lens])
                record = record + 1
            h=l.split(" ")[0][1:]
            lens=0
        else:
            lens=lens+len(l)
    return(out)

def parse_fasta_index(p):
    out=[]
    for e in enumerate(open(p,"r")):
        i=e[0]
        l=e[1]
        l=l.rstrip('\n')
        if l[0] == ">":
            out.append(l[1:].split("|")[0])
    return(out)

def merge_two_dicts(x, y):
    z = x.copy()   # start with x's keys and values
    z.update(y)    # modifies z with y's keys and values & returns None
    return z

mf = parse_fasta(mfp)
smfo = sorted(mf,key=lambda x: x[1],reverse=True)
#print smfo[1:10]

smf=parse_fasta_index(smfp)

converter = {}
for e in enumerate(smfo):
    i=e[0]
    h=e[1][0].split("|")[0]
    #print h
    l=e[1][1]
    if i<len(smf):
        converter[h] = smf[i]

for e in enumerate(open(bfp,"r")):
    i=e[0]
    l=e[1].rstrip('\n')
    sl=l.split()
    scafname=sl[0]
    try:
        newscafname = converter[scafname]
        print "\t".join([newscafname,sl[1],sl[2]])
    except KeyError:
        print "\t".join(["unknown",sl[1],sl[2]])

