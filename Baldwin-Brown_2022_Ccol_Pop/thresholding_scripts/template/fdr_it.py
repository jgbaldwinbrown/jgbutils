#!/usr/bin/env python3

from fdr import fdr
import sys
import numpy as np

def fdr_it(inconn):
    lines = inconn.readlines()
    ps = [float(x.rstrip('\n').split('\t')[-1]) for x in lines]
    fdr_out = fdr(ps)
    lps = [-x for x in np.log10(fdr_out["pvals_corrected"])]
    for index, line in enumerate(lines):
        line = line.rstrip('\n')
        out = [
            line,
            fdr_out["reject"][index],
            fdr_out["pvals_corrected"][index],
            lps[index],
            fdr_out["alphacBonf"]
        ]
        print("\t".join(map(str, out)))

def main():
    fdr_it(sys.stdin)

if __name__ == "__main__":
    main()
