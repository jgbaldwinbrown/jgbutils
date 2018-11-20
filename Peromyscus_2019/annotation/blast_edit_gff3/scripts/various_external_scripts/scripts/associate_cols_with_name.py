#!/usr/bin/env python

import sys

targetpath = sys.argv[1]
templatepath = sys.argv[2]

targetcols = map(int,sys.argv[3].split(','))
templatecols = map(int,sys.argv[4].split(','))
templatenamecol = int(sys.argv[5])

assocs = {}

def genkey(sline,cols):
    return tuple([sline[x] for x in cols])

for entry in enumerate(open(templatepath,"r")):
    if entry[0] == 0:
        continue
    sline = entry[1].split()
    chrompos = genkey(sline,templatecols)
    assocs[chrompos] = sline[templatenamecol]

for entry in enumerate(open(targetpath,"r")):
    if entry[0] == 0:
        print entry[1].rstrip('\n') + "\tsnpname"
        continue
    line = entry[1].rstrip('\n')
    sline = line.split()
    chrompos = genkey(sline,targetcols)
    try:
        mysnpname = assocs[chrompos]
    except KeyError:
        mysnpname = unknown
    print line + "\t" + str(mysnpname)

