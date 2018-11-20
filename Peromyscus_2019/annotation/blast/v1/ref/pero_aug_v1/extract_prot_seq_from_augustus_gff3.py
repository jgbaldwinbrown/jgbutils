#!/usr/bin/env

import fileinput

#data = [x.rstrip('\n') for x in fileinput.input()]

class gene(object):
    def __init__(self):
        self.name = ""
        self.transcripts = []
    def printProtSeqs(self):
        for tran in self.transcripts:
            outheader = ">" + tran.name
            outseq = tran.protseq
            print outheader
            print outseq

class transcript(object):
    def __init__(self):
        self.genename = ""
        self.name = ""
        self.protseq = ""

active_gene = False
active_prot = False
for line in fileinput.input():
    line = line.rstrip('\n')
    if "# start gene" in line:
        mygene = gene()
        mygene.name = line.split()[3]
        active_gene = True
    elif active_gene and "\ttranscript\t" in line:
        tname_to_grab = line.split()[8].split(";")[0].split("=")[1]
        mygene.transcripts.append(transcript())
        mygene.transcripts[-1].genename = mygene.name
        mygene.transcripts[-1].name = tname_to_grab
    elif active_gene and "# protein sequence =" in line and len(mygene.transcripts) > 0:
        if "]" not in line:
            mygene.transcripts[-1].protseq += line.split("[")[1]
            active_prot = True
        else:
            mygene.transcripts[-1].protseq += line.split("[")[1].split("]")[0]
            active_prot = False
    elif active_gene and active_prot:
        if "]" not in line:
           mygene.transcripts[-1].protseq += line.split()[1]
        else:
           mygene.transcripts[-1].protseq += line.split()[1].split("]")[0]
           active_prot = False
    elif "# end gene" in line:
        mygene.printProtSeqs()
        active_gene = False
        active_prot = False

