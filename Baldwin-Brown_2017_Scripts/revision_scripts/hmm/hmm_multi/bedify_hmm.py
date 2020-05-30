#!/usr/bin/env python3

import argparse
import sys

def parse_all_args():
    parser = argparse.ArgumentParser("Combine contiguous hmm hits into bed peaks")
    parser.add_argument("input", help="input data; - for stdin")
    parser.add_argument("-c", "--chrom_col", help="chromosome column", required=True)
    parser.add_argument("-b", "--bp_col", help="basepair position column", required=True)
    parser.add_argument("-v", "--viterbi_col", help="HMM Viterbi output column", required=True)
    parser.add_argument("-H", "--header", help="Indicate that input file has a header line", action="store_true")
    args = parser.parse_args()
    args.viterbi_col = int(args.viterbi_col)
    args.bp_col = int(args.bp_col)
    args.chrom_col = int(args.chrom_col)
    if args.input == "-":
        args.input = sys.stdin
    else:
        args.input = open(args.input, "r")
    return(args)

def print_entry(chrom, start, end, vit, line):
    print("\t".join(map(str, [chrom, start, end, vit, line])))

def bedify_hmm(args):
    out = []
    for i, l in enumerate(args.input):
        l=l.rstrip('\n')
        if args.header and i==0:
            print("chrom\tstart\tend\thmm\t" + l)
            continue
        sl = l.split()
        chrom = sl[args.chrom_col]
        bp = int(sl[args.bp_col])
        viterbi = int(sl[args.viterbi_col])
        out.append({
            "chrom": chrom,
            "bp": bp,
            "viterbi": viterbi,
            "line": l
        })
    out.sort(key = lambda x: (x["chrom"], x["bp"]))
    prevchr = ""
    prevbp = -1
    start = -1
    end = -1
    prev_vit = -1
    prev_l = None
    printed = False
    for l in out:
        if (prevchr != l["chrom"] or l["viterbi"] != 2) and prev_vit == 2:
            end = prevbp
            print_entry(prevchr, start, end, prev_vit, prev_l)
            printed = True
        if (prev_vit != 2 or prevchr != l["chrom"]) and l["viterbi"] == 2:
            start = l["bp"] - 1
            printed = False
        prevchr = l["chrom"]
        prevbp = l["bp"]
        prev_vit = l["viterbi"]
        prev_l = l["line"]
    if not printed:
        print_entry(prevchr, start, end, prev_vit, prev_l)

def main():
    args = parse_all_args()
    bedify_hmm(args)
    args.input.close()

if __name__ == "__main__":
    main()
