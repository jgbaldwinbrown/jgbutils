#!/bin/python
import sys
from Bio import SeqIO
import random
from random import randrange
import sys
cmd = sys.argv
pbreads = str(sys.argv[1])
seed = int(sys.argv[3])
out_prefix = str(sys.argv[2])
reps1 = int(sys.argv[4])
reps2 = int(sys.argv[5])
reps3 = int(sys.argv[6])
random.seed(seed)

out1 = []
out2 = []
out1path = out_prefix + "_forward_3kb.fa"
out2path = out_prefix + "_reverse_3kb.fa"
for record in SeqIO.parse(pbreads,"fasta"):
        if len(record) >= 3100:
                for i in range(0,reps1):
                        pos = randrange(0,len(record)-3001)
                        readlen = 3000
                        out1.append(record[pos:pos+101].reverse_complement())
                        out2.append(record[pos+readlen-100:pos+readlen+1])
SeqIO.write(out1,out1path,"fasta")
SeqIO.write(out2,out2path,"fasta")

out1 = []
out2 = []
out1path = out_prefix + "_forward_10kb.fa"
out2path = out_prefix + "_reverse_10kb.fa"
for record in SeqIO.parse(pbreads,"fasta"):
	if len(record) >= 10100:
		for i in range(0,reps2):
			pos = randrange(0,len(record)-10001)
			readlen = 10000
			out1.append(record[pos:pos+101].reverse_complement())
			out2.append(record[pos+readlen-100:pos+readlen+1])
SeqIO.write(out1,out1path,"fasta")
SeqIO.write(out2,out2path,"fasta")

out1 = []
out2 = []
out1path = out_prefix + "_forward_15kb.fa"
out2path = out_prefix + "_reverse_15kb.fa"
for record in SeqIO.parse(pbreads,"fasta"):
	if len(record) >= 15100:
		for i in range(0,reps3):
			pos = randrange(0,len(record)-15001)
			readlen = 15000
			out1.append(record[pos:pos+101].reverse_complement())
			out2.append(record[pos+readlen-100:pos+readlen+1])
SeqIO.write(out1,out1path,"fasta")
SeqIO.write(out2,out2path,"fasta")
