#!/usr/bin/env python3

import fileinput

def print_chrlens(chrlens):
    for entry in chrlens:
        print("\t".join(map(str, [entry["chrom"], entry["len"], entry["index"], entry["index_1"], entry["cumsum"]])))

def sorted_chrlens(chrlens):
    s = sorted(chrlens, key=lambda x: x["len"], reverse=True)
    cumsum = 0
    for i, chrentry in enumerate(s):
        chrentry["index"] = i
        chrentry["index_1"] = i+1
        cumsum += chrentry["len"]
        chrentry["cumsum"] = cumsum
    return(s)

def get_chrlens(inconn):
    header = ""
    seqlen = 0
    out = []
    
    for aline in inconn:
        line = aline.rstrip('\n')
        if len(line) > 0:
            if line[0] == ">":
                if len(header) > 0 and seqlen > 0:
                    out.append({"chrom": header[1:], "len": seqlen})
                header = line
                seqlen = 0
            else:
                seqlen = seqlen + len(line)
    out.append({"chrom": header[1:], "len": seqlen})
    return(out)

def main():
    chrlens = get_chrlens(fileinput.input())
    chrlens = sorted_chrlens(chrlens)
    print_chrlens(chrlens)

if __name__ == "__main__":
    main()
