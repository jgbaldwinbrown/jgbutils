#!/usr/bin/env python
import sys
#import fileinput

def mean(numbers):
    return float(sum(numbers)) / max(len(numbers), 1)

#def 

paths=sys.argv[1:]
done = False
colindex = 0
outdata={}
while not done:
    data = {}
    for pathentry in enumerate(paths):
        pathindex = pathentry[0]
        path = pathentry[1]
        mysnpnames = set([])
        for entry in enumerate(open(path,"r")):
            index = entry[0]
            line = entry[1]
            sline = line.rstrip('\n').split()
            snpname = sline[0]
            if pathindex == 0 and index == 0 and colindex == 0:
                ncols = len(sline)
                colindex = 1
            if snpname in mysnpnames or snpname[0] != "s" or "s" in line[1:]:
                continue
            else:
                mysnpnames.add(snpname)
            snpdata = float(sline[colindex])
            if snpname not in data:
                data[snpname] = [snpname,[snpdata]]
            else:
                data[snpname][1].append(snpdata)
    
    for snpname in data:
        if snpname not in outdata:
            outdata[snpname] = [snpname,[]]
        outdata[snpname][1].append(mean(data[snpname][1]))
    #sys.stderr.write(str(colindex) + "\n")
    colindex += 1
    if colindex >= ncols:
        done = True

for entry in sorted(outdata.itervalues(),key=lambda x: int(x[0].split("s")[-1])):
    outlist = [entry[0]]
    outlist.extend(entry[1])
    print "\t".join(map(str,outlist))

