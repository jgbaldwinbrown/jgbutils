#!/usr/bin/env python
from __future__ import print_function
from operator import itemgetter
import sys

def eprint(*args, **kwargs):
    print(*args, file=sys.stderr, **kwargs)

def printheader(line):
    outline = line
    if add_sort_var: outline = outline + "\t" + "sort_variable"
    if add_index_var: outline = outline + "\t" + "index_variable"
    print(outline)

def printentry(line,sortindex):
    global snpindex
    outline = line
    if add_sort_var: outline = outline + "\t" + str(sortindex)
    if add_index_var: outline = outline + "\t" + str(snpindex)
    print(outline)
    snpindex += 1
    

args = sys.argv

if len(args) != 7:
    exit ("must have 6 arguments!")

infile = args[1]
chromorderfile = args[2]
chromcol = int(args[3])
header = True if args[4] == "True" else False
add_sort_var = True if args[5] == "True" else False
add_index_var = True if args[6] == "True" else False

if infile == "-":
    inconnect = sys.stdin
else:
    inconnect = open(infile,"r")

with open(chromorderfile,"r") as file:
    chromorder = {}
    for line in file:
        sline = line.rstrip('\n').split()
        chrom = sline[0]
        order = sline[1]
        chromorder[chrom] = order

snpindex=0
numbered_data = []
for entry in enumerate(inconnect):
    index = entry[0]
    line = entry[1].rstrip('\n')
    if index == 0 and header == True:
        printheader(line)
        continue
    sline = line.split()
    chrom = sline[chromcol].strip('"')
    try:
        order = chromorder[chrom]
    except KeyError:
        eprint("chromosome "+chrom+" not in order file.  Appending to beginning of file.")
        order = -1
    numbered_data.append((line,order))

numbered_data = sorted(numbered_data,key=itemgetter(1))

for entry in numbered_data:
    printentry(entry[0],entry[1])

