#!/usr/bin/env python3

import tempfile
import sys
import argparse
import os
import subprocess

def parse_all_args():
    parser = argparse.ArgumentParser("Runs npstat on multiple-chromosome fasta")
    parser.add_argument("infile", help="input pileup file")
    parser.add_argument("-n", "--sample_size", help="haploid sample size", required=True)
    parser.add_argument("-l", "--window_length", help="window length in bases", required=True)
    parser.add_argument("-c", "--minimum_coverage", help="minimum coverage (default 4)")
    parser.add_argument("-C", "--maximum_coverage", help="maximum coverage (default 100)")
    parser.add_argument("-q", "--minimum_quality", help="minimum quality (default 10)")
    parser.add_argument("-f", "--no_low_freq", help="minimum allele count (default 1)")
    parser.add_argument("-o", "--outgroup", help="outgroup file (FASTA)")
    parser.add_argument("-s", "--snpfile", help="consider SNPs only if present in snpfile")
    parser.add_argument("-a", "--annot", help="annotation file (GFF3)")
    parser.add_argument("-S", "--sorted", help="specify that pileup is already sorted by sequence (default = False)", action="store_true")
    parser.add_argument("-p", "--prefix", help="prefix for output files")

    args = parser.parse_args()
    
    return(args)

def read_pileup(infile):
    if infile == "-":
        inconn = sys.stdin
    else:
        inconn = open(infile, "r")
    
    data = []
    for l in inconn:
        sl = l.rstrip('\n').split('\t')
        data.append(sl)
    inconn.close()
    return(data)

def sorted_pileup(data):
    return(sorted(data, key=lambda x: x[0]))

def get_pileup_chroms(data):
    return(set([x[0] for x in data]))

def write_chrompile(ifile, data):
    for l in data:
        ifile.write("\t".join(l) + "\n")

def run_npstat(chrom, data, args):
    basecom = ["npstat", "-n", args.sample_size]
    if args.prefix:
        ipath = args.prefix + "_" + chrom + "_npstat.pileup"
    else:
        ipath = "out" + "_" + chrom + "_npstat.pileup"
    ifile = open(ipath, "w")
    write_chrompile(ifile, data)
    ifile.close()

    basecom.extend(["-l", args.window_length])
    if args.minimum_coverage:
        basecom.extend(["-mincov", args.minimum_coverage])
    if args.maximum_coverage:
        basecom.extend(["-maxcov", args.maximum_coverage])
    if args.minimum_quality:
        basecom.extend(["-minqual", args.minimum_quality])
    if args.no_low_freq:
        basecom.extend(["-nolowfreq", args.no_low_freq])
    if args.outgroup:
        basecom.extend(["-outgroup", args.outgroup])
    if args.snpfile:
        basecom.extend(["-snpfile", args.snpfile])
    if args.annot:
        basecom.extend(["-annot", args.annot])
    basecom.extend([ipath])
    
    # subprocess.run(["cat", ipath]) #debug
    # print(basecom) #debug
    
    subprocess.run(basecom)
    os.remove(ipath)

def get_opaths(chroms, args):
    opaths = {}
    for chrom in chroms:
        if args.prefix:
            opath = args.prefix + "_" + chrom + "_npstat.pileup.stats"
        else:
            opath = "out" + "_" + chrom + "_npstat.pileup.stats"
        opaths[chrom] = opath
    return(opaths)

def combine_and_write(ipaths, args):
    if args.prefix:
        opath = args.prefix + ".stats"
    else:
        opath = "out.stats"
    with open(opath, "w") as ofile:
        first_header = True
        for chrom, ipath in ipaths.items():
            with open(ipath, "r") as ifile:
                for i, l in enumerate(ifile):
                    if i == 0:
                        if first_header:
                            ofile.write("chrom\t" + l)
                        first_header = False
                    else:
                        ofile.write(chrom + "\t" + l)

def main():
    args = parse_all_args()
    data = read_pileup(args.infile)
    if not args.sorted:
        data = sorted_pileup(data)
    chroms = get_pileup_chroms(data)
    opaths = get_opaths(chroms, args)
    # print(data) #debug
    # print(chroms) #debug
    for chrom in chroms:
        run_npstat(chrom, data, args)
    combine_and_write(opaths, args)

if __name__ == "__main__":
     main()
