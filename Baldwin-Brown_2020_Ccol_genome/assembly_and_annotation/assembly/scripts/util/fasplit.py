#!/usr/bin/env python3

def write_seq(prefix, header, seq):
    opath = prefix + header[1:] + ".fa.gz"
    with gzip.open(opath, "wb") as ofile:
        ofile.write((header + "\n").encode('utf-8'))
        ofile.write((seq + "\n").encode('utf-8'))

if __name__ == "__main__":
    import sys
    import argparse
    import gzip

    parser = argparse.ArgumentParser("Split a fasta into 1 file per record.")
    parser.add_argument("fasta", nargs='?', help="Input fasta file (default is stdin).")
    parser.add_argument("-p", "--prefix", help="prefix for output files (default is no prefix).")
    args = parser.parse_args()

    if not args.fasta:
        fasta = stdin
    else:
        fasta = open(args.fasta, "r")

    if not args.prefix:
        prefix = ""
    else:
        prefix = args.prefix

    header = ""
    seq = ""
    for l in fasta:
        l = l.rstrip('\n')
        if len(l) <= 0:
            pass
        elif l[0] == ">":
            if len(header) > 0 and len(seq) > 0:
                write_seq(prefix, header, seq)
            header = l
            seq = ""
        else:
            seq += l
    if len(header) > 0 and len(seq) > 0:
        write_seq(prefix, header, seq)

    fasta.close()
