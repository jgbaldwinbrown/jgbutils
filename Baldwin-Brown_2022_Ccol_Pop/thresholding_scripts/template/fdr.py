#!/usr/bin/env python3

import sys
from statsmodels.stats.multitest import multipletests

def fdr(ps):
    fdr_out = multipletests(ps, alpha=0.05, method="fdr_bh", is_sorted=False, returnsorted=False)
    out = {
        "reject": fdr_out[0],
        "pvals_corrected": fdr_out[1],
        "alphacSidac": fdr_out[2],
        "alphacBonf": fdr_out[3]
    }
    return(out)
    # reject = out.reject
    # pvals_corrected = fdr_out.pvals_corrected
    # alphacSidak = 

def print_lines(ps, corr):
    for index in range(len(ps)):
        out = [ps[index], corr["pvals_corrected"][index], corr["reject"][index], corr["alphacSidac"], corr["alphacBonf"]]
        print("\t".join(map(str, out)))

def main():
    ps = [float(x.rstrip('\n')) for x in sys.stdin]
    out = fdr(ps)
    print_lines(ps, out)

if __name__ == "__main__":
    main()
