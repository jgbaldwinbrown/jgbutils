#!/usr/bin/env python3

import sys
import re

def gff_parse(inconn):
    parentre = re.compile(r"Parent=([^ 	;]*(gene-[0-9.]*)[^ 	;]*)")
    out = {}
    for l in inconn:
        l = l.rstrip('\n')
        sl = l.split('\t')
        chrom = sl[0]
        start = int(sl[3]) - 1
        end = int(sl[4])
        parent_match = parentre.search(sl[8])
        parent_name = parent_match.group(1)
        parent_gene = parent_match.group(2)
        out[(chrom, start, end)] = {
            "chrom": chrom,
            "start": start,
            "end": end,
            "parent_name": parent_name,
            "parent_gene": parent_gene,
            "entry": sl,
        }
    return(out)

def fa_parse(inconn):
    header = ""
    seq = ""
    for l in inconn:
        l = l.rstrip('\n')
        if len(l) <= 0:
            continue
        if l[0] == ">":
            if len(header) > 0 and len(seq) > 0:
                yield((header, seq))
            header = l[1:]
            seq = ""
        else:
            seq = seq + l
    if len(header) > 0 and len(seq) > 0:
        yield((header, seq))

def fa_header_parse(header):
    headerre = re.compile(r"([^:]*):([^-]*)-([^-]*)")
    header_match = headerre.search(header)
    chrom = header_match.group(1)
    start = int(header_match.group(2))
    end = int(header_match.group(3))
    return((chrom, start, end))

def main():
    with open(sys.argv[1], "r") as inconn:
        gff_info = gff_parse(inconn)
    outprefix = sys.argv[2]
    allgenes = {}
    with open(outprefix + "_split.fa", "w") as splitoutconn:
        for header, seq in fa_parse(sys.stdin):
            
            pos_id = fa_header_parse(header)
            parent = (pos_id[0], gff_info[pos_id]["parent_gene"])
            header = header + "; " + gff_info[pos_id]["parent_gene"]
            splitoutconn.write(">" + header + "\n")
            splitoutconn.write(seq + "\n")
            if parent not in allgenes:
                allgenes[parent] = []
            allgenes[parent].append((parent, header, seq))
    with open(outprefix + "_joined.fa", "w") as joinedoutconn:
        for parent, exons in allgenes.items():
            header = parent[0] + "; " + parent[1]
            seq = ""
            for exon in exons:
                seq = seq + exon[2]
            joinedoutconn.write(">" + header + "\n")
            joinedoutconn.write(seq + "\n")

if __name__ == "__main__":
    main()
