#!/usr/bin/env python3

import sys
import re

def get_ids(inconn):
    bads = set([])
    idre = re.compile(r"ID=([^;]*);")
    for l in inconn:
        l = l.rstrip('\n')
        sl = l.split('\t')
        nine = sl[8]
        id = idre.search(nine).group(1)
        bads.add(id)
    return(bads)

def print_if_good(entry, bads):
    if len(entry) > 0:
        id = entry.split('\t')[0]
        if id not in bads:
            print(entry)

def strip_bads(inconn, bads):
    for l in inconn:
        l = l.rstrip('\n')
        if len(l) == 0:
            pass
        elif l[0] == "#":
            print(l)
        else:
            print_if_good(l, bads)

def main():
    with open(sys.argv[1], "r") as inconn:
        bads = get_ids(inconn)
    strip_bads(sys.stdin, bads)

if __name__ == "__main__":
    main()
