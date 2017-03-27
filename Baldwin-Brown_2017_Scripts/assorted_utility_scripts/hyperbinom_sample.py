#!/usr/bin/env python

import numpy
import itertools

def rbinomhyper_2list(freqs,covs,covfrac,rseed):
    try:
        mycovfrac=float(covfrac)
    except ValueError:
        exit("fraction of coverage to keep must be a float between 0 and 1")
    if len(freqs) != len(covs):
        exit("number of frequencies must match number of coverages!")
    numpy.random.RandomState(rseed)
    #outcovs = numpy.random.binomial(covs,mycovfrac)
    #hypergoodin = [int(round(a*b)) for a,b in itertools.izip(freqs,covs)]
    #hyperbadin = [int(b-a) for a,b in itertools.izip(hypergoodin,covs)]
    #outhits = numpy.random.hypergeometric(hypergoodin,hyperbadin,outcovs)
    #outfreqs = [float(a)/float(b)
    #return(zip(hypergoodin
    outlist=[]
    for f,c in itertools.izip(freqs,covs):
        #print "f=" + f
        #print "c=" + c
        try:
            f=float(f)
            c=int(c)
        except ValueError:
            outlist.append(("NA",0))
            continue
        newc = numpy.random.binomial(c,mycovfrac)
        hypergoodin = int(round(f*c))
        hyperbadin = c-hypergoodin
        if newc <= 0:
            newf= "NA"
        else:
            if hypergoodin <= 0:
                newhits=0
            elif hyperbadin <= 0:
                newhits=newc
            else:
                newhits = numpy.random.hypergeometric(hypergoodin,hyperbadin,newc)
            newf = float(newhits)/float(newc)
        outlist.append((newf,newc))
    return outlist

def rbinomhyper_file(infile,infreqcol,incovcol,covfrac,rseed,hasheader):
    freqs=[]
    covs=[]
    with open(infile,"r") as file:
        for entry in enumerate(file):
            index=entry[0]
            line=entry[1]
            if hasheader and index==0:
                continue
            sline = line.rstrip('\n').split()
            f=sline[infreqcol]
            c=sline[incovcol]
            freqs.append(f)
            covs.append(c)
    return rbinomhyper_2list(freqs,covs,covfrac,rseed)

def rbinomhyper_file_fullprint(infile,infreqcol,incovcol,covfrac,rseed,hasheader):
    newfclist = rbinomhyper_file(infile,infreqcol,incovcol,covfrac,rseed,hasheader)
    with open(infile,"r") as file:
        for entry in enumerate(file):
            index = entry[0]
            line = entry[1]
            if hasheader and index==0:
                print line.rstrip('\n')
                continue
            sline = line.rstrip('\n').split()
            newfcindex = index - 1 if hasheader else index
            fout=newfclist[newfcindex][0]
            cout=newfclist[newfcindex][1]
            sline[infreqcol] = fout
            sline[incovcol] = cout
            print "\t".join(map(str,sline))

def main():
    import sys
    
    args=sys.argv
    infile=str(args[1])
    infreqcol=int(args[2])
    incovcol=int(args[3])
    covfrac=float(args[4])
    hasheader= True if args[5] == "True" else False
    hasrseed=False
    if len(args) >= 7:
        rseed = int(args[6])
        hasrseed=True
    
    rbinomhyper_file_fullprint(infile,infreqcol,incovcol,covfrac,rseed,hasheader)

if __name__ == "__main__":
    main()
