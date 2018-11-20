#!/usr/bin/env python
import sys

xtx_out_path = sys.argv[1]
bf_out_path = sys.argv[2]
snptable_path = sys.argv[3]
chromlist = sys.argv[4]

chroms = {}
chromindex = {}

for line in open(chromlist,"r"):
    sline=line.strip().split()
    chromnum=sline[0]
    chrom=sline[1]
    chromlen=sline[2]
    chromindex[chrom] = [chromnum,chromlen]

started = False
for entry in enumerate(open(snptable_path,"r")):
    if started:
        index = int(entry[0])
        sline = entry[1].rstrip('\n').split()
        chromname=sline[1]
        chrompos=sline[2]
        chromnum = chromindex[chromname][0]
        chromlen = chromindex[chromname][1]
        chroms[index] = [chromname,chrompos,chromnum,chromlen]
    started = True

xtx_values = {}
xtx_values_batch_index = {}
for entry in enumerate(open(xtx_out_path,"r")):
    index = entry[0]
    line = entry[1].rstrip('\n')
    xtx_values[index] = line
    xtx_batch_index = int(line.split()[0].split("s")[1])
    xtx_value = float(line.split()[1])
    xtx_values_batch_index[xtx_batch_index] = xtx_value

started=False
for entry in enumerate(open(bf_out_path,"r")):
    loopindex = entry[0]
    if loopindex == 1:
        bfentrynum = len(line.rstrip('\n').split())
    line = entry[1]
    sline = line.rstrip('\n').split()
    #if len(sline) == 2:
    try:
        index = int(sline[0].split("s")[1])
        genpos = sline[0]
        value = map(float,sline[1:])
    except IndexError:
        xtx_entry = xtx_values[loopindex]
        index = int(xtx_entry[0])
        genpos = xtx_entry[0]
        value = map(float,sline[1:])
    try:
        chrominfo = chroms[index]
    except KeyError:
        chrominfo = ["unknown_chrom","NA","NA","NA"]
    try:
        myxtxval = xtx_values_batch_index[index]
    except KeyError:
        myxtxval = "NA"
    
    #print "\t".join(map(str,chrominfo)) #debug
    #outline = map(str,[index,genpos,value,chrominfo[0],chrominfo[1],chrominfo[2],chrominfo[3],myxtxval])
    outline = map(str,[index,genpos])
    outline.extend(map(str,value))
    outline.extend(map(str,[chrominfo[1],chrominfo[2],chrominfo[3],myxtxval]))
    print "\t".join(outline)

