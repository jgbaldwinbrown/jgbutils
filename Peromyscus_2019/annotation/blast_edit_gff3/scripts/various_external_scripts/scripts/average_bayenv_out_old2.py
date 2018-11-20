#!/usr/bin/env python
import sys
#import fileinput

def mean(numbers):
    return float(sum(numbers)) / max(len(numbers), 1)

#def 

#paths = [x.rstrip('\n') for x in fileinput.input()]
paths=sys.argv[1:]
data = {}
for path in paths:
    mysnpnames = set([])
    for entry in enumerate(open(path,"r")):
        index = entry[0]
        line = entry[1]
        sline = line.rstrip('\n').split()
        snpname = sline[0]
        snpdata = map(float,sline[1:])
        if snpname in mysnpnames:
            continue
        else:
            mysnpnames.add(snpname)
        #sys.stderr.write("snpname="+str(snpname)+"\n")
        #sys.stderr.write("snpdata="+str(snpdata)+"\n")
        if snpname not in data:
            data[snpname] = [snpname,[[x] for x in snpdata]]
            #sys.stderr.write("data[snpname]="+str(data[snpname])+"\n")
        else:
            if len(data[snpname][1]) != len(snpdata):
                #sys.stderr.write("Incoorectly formatted line. Path="+str(path)+"; line="+str(index)+"; name="+str(snpname)+"\n")
                continue
            for i in xrange(len(snpdata)):
                #sys.stderr.write("data[snpname][1]="+str(data[snpname][1])+"\n")
                data[snpname][1][i].append(snpdata[i])

for snpname in data:
    data[snpname].append(map(mean,data[snpname][1]))
    #sys.stderr.write("data[snpname]="+str(data[snpname])+"\n")

for entry in sorted(data.itervalues(),key=lambda x: int(x[0].split("s")[-1])):
    #sys.stderr.write("entry[0]="+entry[0]+"\n")
    #sys.stderr.write("entry[2]="+str(entry[2])+"\n")
    outlist = [entry[0]]
    outlist.extend(entry[2])
    #sys.stderr.write("outlist="+str(outlist)+"\n")
    print "\t".join(map(str,outlist))

