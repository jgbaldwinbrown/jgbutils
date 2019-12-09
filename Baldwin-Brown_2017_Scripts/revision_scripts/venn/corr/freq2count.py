#!/usr/bin/env python3

import sys

def main():
    for l in sys.stdin:
        sl = l.rstrip('\n').split()
        out = sl[:3]
        for freq, count in zip(sl[8::2], sl[9::2]):
            try:
                freqn = float(freq)
                countn = float(count)
                c1 = str(int(round(freqn * countn)))
                c2 = str(int(round((1 - freqn) * countn)))
            except ValueError:
                c1 = "NA"
                c2 = "NA"
            out.append(c1)
            out.append(c2)
        print("\t".join(out))

if __name__ == "__main__":
    main()
