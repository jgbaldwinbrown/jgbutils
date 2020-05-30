#!/usr/bin/env python3

import sys

def main():
    if sys.argv[1] != "-":
        inconn = open(sys.argv[1], "r")
    else:
        inconn = sys.stdin
    indexconn = open(sys.argv[2], "w")

    for i, l in enumerate(inconn):
        l = l.rstrip('\n')
        sl = l.split()
        ok = True
        for p, q in zip(sl[::2], sl[1::2]):
            p = int(p)
            q = int(q)
            if p + q < 10:
                ok = False
        if ok:
            print(l)
            indexconn.write(str(i) + "\t" + "PASS\n")
        else:
            indexconn.write(str(i) + "\t" + "FAIL\n")

    inconn.close()
    indexconn.close()

if __name__ == "__main__":
    main()

