#!/usr/bin/env python

import subprocess
import sys
import argparse

#Required:
#the 'nucmer','delta-filter', and 'merger' executables must be in the user's PATH

parser = argparse.ArgumentParser(description = 'Use quickmerge output and fasta files to annotate merge locations in merged sequences.')
parser.add_argument("-f","--outfmt", help="Format of annotation file (default=bed)")
parser.add_argument("-i","--initial_fasta_1", help="Path to first initial fasta")
parser.add_argument("-j","--initial_fasta_2", help="Path to second initial fasta")
parser.add_argument("-m","--merged_fasta", help="Path to merged fasta")
parser.add_argument("-l","--location_file", help="path to output of quickmerge (location file)")

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
if args.outfmt:
    outfmt=args.outfmt
else:
    outfmt="bed"

if not args.initial_fasta_1:
    exit("initial fasta 1 is required!")
else:
    ifp1 = args.initial_fasta_1

if not args.initial_fasta_2:
    exit("initial fasta 2 is required!")
else:
    ifp2 = args.initial_fasta_2

if not args.merged_fasta:
    exit("merged fasta is required!")
else:
    mfp = args.merged_fasta

if not args.location_file:
    exit("location file is required!")
else:
    lfp = args.location_file

def parse_fasta(p):
    out={}
    h=""
    lens=0
    record = 0
    for l in open(p,"r"):
        l=l.rstrip('\n')
        if l[0] == ">":
            if lens > 0 and len(h) > 0:
                out[h]=[record,lens]
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
            out.append(l[1:])
    return(out)

def merge_two_dicts(x, y):
    z = x.copy()   # start with x's keys and values
    z.update(y)    # modifies z with y's keys and values & returns None
    return z

if1 = parse_fasta(ifp1)
#for key,value in if1.iteritems()[0:5]:
#    print str(key) + "\t" + str(value)
if2 = parse_fasta(ifp2)
#for key,value in if1.iteritems()[0:5]:
#    print str(key) + "\t" + str(value)
#mf = parse_fasta_index(mfp)

iff=merge_two_dicts(if1,if2)


curscaf=[]
for e in enumerate(open(lfp,"r")):
    i=e[0]
    l=e[1].rstrip('\n')
    sl=l.split()
    scafname=sl[0]
    contigs=sl[1::2]
    dirs=sl[2::2]
    lens=[iff[x][1] for x in contigs]
    cumlen = 0
    cumlens = []
    for x in lens:
        cumlen = cumlen + x
        cumlens.append(cumlen)
    for x in cumlens:
        print "\t".join(map(str,[scafname,x-1,x]))

