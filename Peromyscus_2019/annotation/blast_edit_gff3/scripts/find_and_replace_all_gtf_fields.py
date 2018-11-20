#!/usr/bin/env python
import sys

#get input paths (can be connections, pipes, etc.)
pairpath = sys.argv[1]
inpath = sys.argv[2]

#build hash for pairwise comparisons:
sg2fbgn = {}
st2fbgn = {}
for l in open(pairpath,"r"):
    sl = l.rstrip('\n').split('\t')
    p1=sl[0]
    p2=sl[1]
    sg2fbgn[p1]=p2

#loop over the gtf file
for line in open(inpath,"r"):
    line = line.rstrip('\n')
    sline = line.split('\t')
    #ignore lines that aren't formatted correctly:
    if line[0] == "#" or len(sline) != 9 or sline[2] == "intron":
        print line
        continue
    #split the 9th tab delimited field of the line into semicolon delimited subfields:
    fields = sline[8].strip(";").split(";")
    #parse these fields, so that for any given entry, entry[0] is the first part (assuming splitting by spaces), entry[1] is the second part, with quotes stripped, and entry[2] is the full entry
    myfields_parsed = [(x.strip().split(" ")[0],x.strip().split(" ")[-1].strip('"'),x) for x in fields]
    #build the new version of the parsed fields:
    outfields_parsed = []
    for field in myfields_parsed:
        #ignore empty fields:
        if len(field[1]) > 0:
            no_tnum = ".".join(field[1].split(".")[0:2])
            try:
                tnum= field[1].split(".")[2]
            except IndexError:
                tnum="none"
            #if the entire field matches a pair, do find-and-replace on the entire field
            if field[2] in sg2fbgn:
                outfields_parsed.append(sg2fbgn[field[2]])
            #if the first part of the field matches "transcript_id" or "gene_id", and the second part matches a pair, do find-and-replace on the second part:
            elif field[0] in ["transcript_id","gene_id"] and field[1] in sg2fbgn:
                outfields_parsed.append(field[0] + ' "' + str(sg2fbgn[field[1]])+'"')
            elif field[0] in ["transcript_id"] and no_tnum in sg2fbgn:
                outfields_parsed.append(field[0] + ' "' + str(sg2fbgn[no_tnum])+"."+str(tnum))
            else:
                #otherwise, do not change the field
                outfields_parsed.append(field[2])
    #join all fields, maintaining correct semicolon and space usage:
    outfields = "; ".join(map(str,outfields_parsed)) + ";"
    #generate and print output line:
    out = sline[:-1]
    out.append(outfields)
    print "\t".join(map(str,out))


