#!/usr/bin/env python
import sys

pairpath = sys.argv[1]
inpath = sys.argv[2]

sg2fbgn = {}
st2fbgn = {}
for l in open(pairpath,"r"):
    sl = l.rstrip('\n').split('\t')
    p1=sl[0]
    p2=sl[1]
    sg2fbgn[p1]=p2

indat=[]
id2parent={}
for line in open(inpath,"r"):
    line = line.rstrip('\n')
    indat.append(line)
    sline = line.split('\t')
    if line[0] == "#" or len(sline) != 9:
        print line
        continue
    fields = sline[8].split(";")
    myid=[(i,v.split("=")[-1]) for i,v in enumerate(fields) if "ID=" in v]
    myparent=[(i,v.split("=")[-1]) for i,v in enumerate(fields) if "Parent=" in v]
    if len(myid) > 0 and len(myparent) > 0:
        myidmini=myid[0][1]
        myparentmini=myparent[0][1]
        id2parent[myidmini] = myparentmini
  
for line in indat:
    line = line.rstrip('\n')
    sline = line.split('\t')
    if line[0] == "#" or len(sline) != 9:
        print line
        continue
    fields = sline[8].split(";")
    myid=[(i,v.split("=")[-1]) for i,v in enumerate(fields) if "ID=" in v]
    myparent=[(i,v.split("=")[-1]) for i,v in enumerate(fields) if "Parent=" in v]
    myfbgn = ""
    if len(myid) > 0:
        if myid[0][1] in sg2fbgn:
            myfbgn = sg2fbgn[myid[0][1]]
        if myid[0][1] in st2fbgn:
            myfbgn = st2fbgn[myid[0][1]]
    elif len(myparent) > 0:
        if myparent[0][1] in sg2fbgn:
            myfbgn = sg2fbgn[myparent[0][1]]
        elif myparent[0][1] in st2fbgn:
            myfbgn = st2fbgn[myparent[0][1]]
        else:
             mytemp = myparent[0][1]
             done = False
             while not done:
                 if mytemp in sg2fbgn:
                     myfbgn = sg2fbgn[mytemp]
                     done = True
                 elif mytemp in id2parent:
                     mytemp = id2parent[mytemp]
                 else:
                     done = True
    if len(myfbgn) > 0:
        fields.append("gene_name="+str(myfbgn))
    out = sline[:-1]
    out.append(";".join(map(str,fields)))
    print "\t".join(map(str,out))


