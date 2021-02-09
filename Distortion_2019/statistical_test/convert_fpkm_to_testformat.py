#!/usr/bin/env python3

import sys
import re

def get_gc(path):
    gcmap = {}
    for l in open(path, "r"):
        sl=l.rstrip('\n').split('\t')
        gcmap[sl[0]] = sl[1]
    return(gcmap)

def get_sample_info(path):
    out = {}
    regex = re.compile(r'\bbam$')
    for l in open(path, "r"):
        l=l.rstrip('\n')
        sl=l.split('\t')
        if regex.search(l):
            name = l.split(".")[0]
            out[name] = {"significance": "1000G", "indiv": name, "sample_index": name, "tissue": "Blood", "sample": name}
            #print("1000G", name, name, "Blood", name, sep="\t")
        else:
            out[sl[4]] = {"significance": sl[0], "indiv": sl[1], "sample_index": sl[2], "tissue": sl[3], "sample": sl[4]}
    return(out)

def get_chrom_conversion(path):
    out = {}
    for l in open(path, "r"):
        sl = l.rstrip('\n').split('\t')
        out[sl[0]] = sl[1]
    return(out)

def main():
    sample_info = get_sample_info(sys.argv[1])
    chrom_gc_info = get_gc(sys.argv[2])
    chrom_conversion = get_chrom_conversion(sys.argv[3])
    print("pos	indiv	value	tissue	chrom	gc	sample")
    colname_map = {"pos": 3, "sample_index": 7, "value": 4, "tissue": 8, "chrom": 1, "sample": 9 }
    for l in sys.stdin:
        l=l.rstrip('\n')
        sl=l.split('\t')
        chrom = chrom_conversion[sl[colname_map["chrom"]]]
        sample = sl[colname_map["sample"]]
        sample_index = sl[colname_map["sample_index"]]
        pos = sl[colname_map["pos"]]
        value = sl[colname_map["value"]]
        tissue = sl[colname_map["tissue"]]
        gc = chrom_gc_info[chrom]
        indiv = sample_info[sample]["indiv"]
        print(pos, indiv, value, tissue, chrom, gc, sample, sep="\t")

if __name__ == "__main__":
    main()
