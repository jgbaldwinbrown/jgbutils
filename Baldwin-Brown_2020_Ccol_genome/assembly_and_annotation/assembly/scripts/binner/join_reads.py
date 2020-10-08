#!/urs/bin/env python

import sys

################################################################################
################################################################################
#functions:

alt_map = {'ins':'0'}
complement = {'A': 'T', 'C': 'G', 'G': 'C', 'T': 'A', 'a': 't', 'c': 'g', 'g': 'c', 't': 'a'}

def reverse_complement(seq):    
    for k,v in alt_map.iteritems():
        seq = seq.replace(k,v)
    bases = list(seq) 
    bases = reversed([complement.get(base,base) for base in bases])
    bases = ''.join(bases)
    for k,v in alt_map.iteritems():
        bases = bases.replace(v,k)
    return bases

################################################################################
################################################################################
#run here:

args = sys.argv[1:]

a_in = open(args[0],"r")
b_in = open(args[1],"r")

a_head=""
a_seq=""
a_qual=""
b_head=""
b_seq=""
b_qual=""

for e in enumerate(a_in):
    i=e[0]
    l=e[1].rstrip('\n')
    bl=b_in.readline().rstrip('\n')
    if i%4==0:
        a_head = l
        b_head = bl
    if i%4==1:
        a_seq = l
        b_seq = bl
        outhead = a_head + "_" + b_head[1:]
        outseq = a_seq + "N" + reverse_complement(b_seq)
        print outhead
        print outseq
    
