#!/usr/bin/env python
import sys

#>>> c=a.split(";")
#>>> d=map(lambda x: x.strip(),c)
#>>> d
#['apple fritter', 'banana', 'carrot pancake', '']
#>>> e=filter(lambda x: len(x) > 0, d)

pairpath = sys.argv[1]
inpath = sys.argv[2]

sg2fbgn = {}
st2fbgn = {}
for l in open(pairpath,"r"):
    sl = l.rstrip('\n').split('\t')
    p1=sl[0]
    p2=sl[1]
    sg2fbgn[p1]=p2
  
for line in open(inpath,"r"):
    line = line.rstrip('\n')
    sline = line.split('\t')
    if line[0] == "#" or len(sline) != 9:
        print line
        continue
    fields = sline[8].strip(";").split(";")
    #myid=[(i,v.split("=")[-1]) for i,v in enumerate(fields) if "ID=" in v]
    #myparent=[(i,v.split("=")[-1]) for i,v in enumerate(fields) if "Parent=" in v]
    mytranscript=[(i,v.strip().split(" ")[-1].strip('"')) for i,v in enumerate(fields) if "transcript_id" in v]
    mygene=[(i,v.strip().split(" ")[-1].strip('"')) for i,v in enumerate(fields) if "gene_id" in v]
    myfbgn = ""
    if len(mytranscript) > 0:
        if mytranscript[0][1] in sg2fbgn:
            myfbgn = sg2fbgn[mytranscript[0][1]]
        if mytranscript[0][1] in st2fbgn:
            myfbgn = st2fbgn[mytranscript[0][1]]
    elif len(mygene) > 0:
        if mygene[0][1] in sg2fbgn:
            myfbgn = sg2fbgn[mygene[0][1]]
        elif mygene[0][1] in st2fbgn:
            myfbgn = st2fbgn[mygene[0][1]]
    if len(myfbgn) > 0:
        fields.append(' gene_name "'+str(myfbgn)+'";')
    out = sline[:-1]
    out.append(";".join(map(str,fields)))
    print "\t".join(map(str,out))


