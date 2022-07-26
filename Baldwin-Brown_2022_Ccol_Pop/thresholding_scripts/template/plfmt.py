#!/usr/bin/env python3

import sys

def plfmt(inconn):
    data = [x.rstrip('\n').split('\t') for x in inconn]
    
    data.sort(key=lambda x: (float(x[0][3:]), float(x[2])))
    
    cumsum = 0
    prevchr = ""
    prevbp = -1
    
    for line in data:
        if line[0] != prevchr:
            cumsum += 1000
        else:
            cumsum += (float(line[2]) - prevbp)
        print("\t".join(line + [line[0][3:], str(cumsum)]))
        prevchr = line[0]
        prevbp = float(line[2])

def main():
    plfmt(sys.stdin)

if __name__ == "__main__":
    main()
