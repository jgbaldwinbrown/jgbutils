#!/usr/bin/env python3

import sys

def main():
    if sys.argv[1] == "-":
        inconn = sys.stdin
    else:
        inconn = open(sys.argv[1], "r")
    names = [x.rstrip('\n') for x in open(sys.argv[2], "r")]

    print(" ".join(names))
    for i, l in enumerate(inconn):
        l=l.rstrip('\n')
        sl = l.split()
        out = []
        for ac1,ac2 in zip(sl[::2], sl[1::2]):
            out.append(ac1 + "," + ac2)
        print(" ".join(out))

if __name__ == "__main__":
    main()
