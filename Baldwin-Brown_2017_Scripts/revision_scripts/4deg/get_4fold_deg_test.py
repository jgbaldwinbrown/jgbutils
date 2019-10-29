#/bin/python

import Bio
from Bio import SeqIO
from Bio.Seq import Seq
import sys
import fnmatch
import itertools

#usage: python get_4fold_deg.py genome.fa annotation.gff3 > out.bed

commands = sys.argv
genomepath = sys.argv[1]
annotationpath = sys.argv[2]

class gene:
  def __init__(self):
    self.transcripts=[]
    self.name=""

class transcript:
  def __init__(self):
    self.cds_starts=[]
    self.cds_ends=[]
    self.cds_strands=[]
    self.cds_frames=[]
    self.start_codon=[]
    self.end_codon=[]
    self.transcript_num=int()
    self.gene_name=""
    self.protein_seq=[]
    self.nuc_seq=[]
    self.trans_nuc_seq=[]
    self.degs=[]
    self.bad=False
    self.nondegs=[]
    self.cleandegs=[]

def readtransline(atranscript,aline):
  splitline = aline.split()
  if splitline[2] == "CDS":
    atranscript.cds_starts.append(int(splitline[3]))
    atranscript.cds_ends.append(int(splitline[4]))
    atranscript.cds_strands.append(str(splitline[6]))
    atranscript.cds_frames.append(int(splitline[7]))
  if splitline[2] == "start_codon":
    atranscript.start_codon.append(int(splitline[3]))
    atranscript.start_codon.append(int(splitline[4]))
  if splitline[2] == "stop_codon":
    atranscript.end_codon.append(int(splitline[3]))
    atranscript.end_codon.append(int(splitline[4]))

deg_codon_prefixes=["GC","CT","CG","CC","TC","AC","GG","GT"]
genes = []

#identify coding sequence:
#	read in all data
#		read in all contigs, keep as strings in a hash
genome = {}
i=0
with open(genomepath) as genomein:
  for line in genomein:
    if i % 2 == 0:
      header = line.rstrip('\n')[1:]
    if i % 2 == 1:
      genome[header] = line.rstrip('\n')
    i += 1

#for key,value in genome.iteritems():
  #print key

#print "done1"
#		read in gff3 file, split into genes.  For each gene, keep these for each transcript: cds coordinates, start codon, stop codon, frame, strand, and protein sequence
with open(annotationpath,"r") as anno:
  while True:
    #print "to read along"
    line = anno.readline().rstrip('\n')
    if not line: break
    #print line
    if fnmatch.fnmatch(line,"# start gene *"):
      mygene = gene()
      mygene.name = line.split(" ")[1]
      genedone = False
      tcount = 0
      while not genedone:
        #print "to continue gene"
        geneline = anno.readline().rstrip('\n')
        #print geneline
        if fnmatch.fnmatch(geneline,"# end gene *"):
          genedone = True
          genes.append(mygene)
          #print genes
          #print type(genes)
        else:
          tcount += 1
          mytranscript = transcript()
          mytranscript.genename = geneline.split('\t')[0]
          mytranscript.transcriptnum = tcount
          #print mytranscript.transcriptnum
          readtransline(mytranscript,geneline)
          trans_done = False
          #print "cds_starts:" + str(len(mytranscript.cds_starts))
          #print "cds_ends:" + str(len(mytranscript.cds_ends))
          #print "start_codon:" + str(len(mytranscript.start_codon))
          #print "end_codon:" + str(len(mytranscript.end_codon))
          while not trans_done:
            #print "to continue trans"
            transline = anno.readline().rstrip('\n')
            #print transline
            if fnmatch.fnmatch(transline,"# protein sequence*"):
              mytranscript.protein_seq = transline.split("[")[1].split("]")[0]
              while not trans_done:
                temp = anno.readline().rstrip('\n')
                if fnmatch.fnmatch(temp,"# incompatible hint groups: 0"):
                  trans_done = True
                elif fnmatch.fnmatch(temp,"# incompatible hint groups: *"):
                  temp = anno.readline()
                  trans_done=True
              mygene.transcripts.append(mytranscript)
            else:
              readtransline(mytranscript,transline)
            #print "cds_starts:" + str(len(mytranscript.cds_starts))
            #print "cds_ends:" + str(len(mytranscript.cds_ends))
            #print "start_codon:" + str(len(mytranscript.start_codon))
            #print "end_codon:" + str(len(mytranscript.end_codon))

#print "done2"

#	get seq for all CDS, splice together
#	identify start and stop, truncate to these
#		get reverse complement if on - strand

for i in range(0,len(genes)):
  mygene = genes[i]
  for j in range(0,len(mygene.transcripts)):
    mytranscript = mygene.transcripts[j]
    myseqlist = []
    myseqposlist = []
    #print len(mytranscript.cds_starts)
    #print len(mytranscript.start_codon)
    #print len(mytranscript.end_codon)
    if len(mytranscript.cds_starts) < 1 or len(mytranscript.start_codon) != 2 or len(mytranscript.end_codon) != 2:
      mytranscript.bad = True
    if mytranscript.bad == False:
      for k in range(0,len(mytranscript.cds_starts)):
        #print mytranscript.cds_starts[k]
        #print mytranscript.cds_ends[k]
        myseqlist.append(genome[mytranscript.genename][(mytranscript.cds_starts[k]):mytranscript.cds_ends[k]-1])
        myseqposlist.append(range(mytranscript.cds_starts[k],mytranscript.cds_ends[k]-1))
      myseq = "".join(myseqlist)
      #print myseq
      myseqpos=list(itertools.chain(*myseqposlist))
      #print myseqpos
      #print "\t".join(map(str,mytranscript.start_codon))
      #print "\t".join(map(str,mytranscript.end_codon))
      if mytranscript.cds_strands[0] == "+":
        myseq = myseq[(mytranscript.start_codon[0] - mytranscript.cds_starts[0]):(mytranscript.cds_ends[len(mytranscript.cds_ends)-1] - mytranscript.end_codon[1])]
        myseqpos = myseqpos[(mytranscript.start_codon[0] - mytranscript.cds_starts[0]):(mytranscript.cds_ends[len(mytranscript.cds_ends)-1] - mytranscript.end_codon[1])]
      elif mytranscript.cds_strands[0] == "-":
        #print "cds_start: " + str(mytranscript.cds_starts[0])
        #print "cds_ends: " + str(mytranscript.cds_ends[len(mytranscript.cds_ends)-1])
        #print "start codon: " + str(mytranscript.start_codon[0]) + " " + str(mytranscript.start_codon[1])
        #print "end codon: " + str(mytranscript.end_codon[0]) + " " + str(mytranscript.end_codon[1])
        #print "end_cut_lengths" + str(mytranscript.end_codon[0] - mytranscript.cds_starts[0]) + str(mytranscript.cds_ends[len(mytranscript.cds_ends)-1] - mytranscript.start_codon[1])
        myseq = myseq[(mytranscript.end_codon[0] - mytranscript.cds_starts[0]):len(myseq) - (mytranscript.cds_ends[len(mytranscript.cds_ends)-1] - mytranscript.start_codon[1])]
        #print "halfdone myseq: " + myseq
        myseq = str(Seq(myseq).reverse_complement())
        myseqpos = myseqpos[(mytranscript.end_codon[0] - mytranscript.cds_starts[0]):len(myseq) - (mytranscript.cds_ends[len(mytranscript.cds_ends)-1] - mytranscript.start_codon[1])]
        #print "halfdone myseqpos: "
        #print myseqpos
        myseqpos = myseqpos[::-1]
      #print "second myseq: " + myseq
      #print "second myseqpos: "
      #print myseqpos
      #	compare to protein seq, make sure similar
      #		100% similarity?
      #will implement protein seq comparison in the future
      #
      #	identify 4-fold degenerate sites and nondegenerate sites
      #		just need a list of coordinates
      for k in range(0,len(myseqpos)-2,3):
        #print myseq
        mycodonpair=myseq[k:k+2]
        #print mycodonpair
        mytranscript.nondegs.append(myseqpos[k])
        mytranscript.nondegs.append(myseqpos[k+1])
        if mycodonpair in deg_codon_prefixes:
          mytranscript.degs.append(myseqpos[k+2])
        else:
          mytranscript.nondegs.append(myseqpos[k+2])
          #	compare all transcripts of gene, remove any 4-fold deg sites that are nondegenerate in another transcript
          #	output a list of all degenerate site coordinates
          #	print mytranscript.genename + "\t" + str(myseqpos[k+2]-1) + "\t" + str(myseqpos[k+2])
      genes[i].transcripts[j].nuc_seq = myseq
      #genes[i].transcripts[j].degs = mytranscript.degs
      #genes[i].transcripts[j].nondegs = mytranscript.nondegs
  #compare all transcripts of gene, remove any 4-fold deg sites that are nondegenerate in another transcript:
  for j in range(0,len(mygene.transcripts)):
    mytranscript = mygene.transcripts[j]
    if len(mytranscript.cds_starts) < 1 or len(mytranscript.start_codon) != 2 or len(mytranscript.end_codon) != 2:
      mytranscript.bad = True
    if mytranscript.bad == False:
      for k in range(0,len(mytranscript.degs)):
        mydeg = mytranscript.degs[k]
        degok = True
        for l in range(0,len(mygene.transcripts)):
          comptranscript = mygene.transcripts[l]
          if mydeg in comptranscript.nondegs: degok=False
        if degok:
          mytranscript.cleandegs.append(mydeg)
          print mytranscript.genename + "\t" + str(mydeg - 1) + "\t" + str(mydeg)


#need to make sure that deg isn't compared to itself? no, it's okay -- it will be a deg, not a nondeg, in its own transcript
#print "done3"

