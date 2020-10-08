#!/bin/python
import sys
from Bio import SeqIO
from Bio.Seq import Seq
from Bio.Alphabet import generic_nucleotide
from Bio.SeqRecord import SeqRecord
import random
from random import randrange
import sys
cmd = sys.argv
refpath = str(sys.argv[1])
outpath = str(sys.argv[2])
#random.seed(seed)

out1 = []
out2 = []
for record in SeqIO.parse(refpath,"fasta"):
	if len(record) >= 100000:
		out1.append(record)
	if len(record) < 100000 and len(record) >= 10000:
		out2.append(record)

out2seq = Seq("", generic_nucleotide)
for r in out2:
	out2seq += r.seq
out2record = SeqRecord(out2seq)
out1.append(out2record)
SeqIO.write(out1,outpath,"fasta")
