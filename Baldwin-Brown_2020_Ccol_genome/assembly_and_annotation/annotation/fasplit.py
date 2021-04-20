#!/usr/bin/env python3

import sys
import argparse
import os
import gzip
from tqdm import tqdm

def parse_all_args():
    parser = argparse.ArgumentParser("Make alternate versions of a .fasta file with a chosen chromosome split in various combinations to identify a problematic location for an aligner or similar")
    parser.add_argument("-r", "--resolution", help="basepair resolution of tiling (default = 1000).", default=1000)
    parser.add_argument("-o", "--out_dir", help="Directory to contain all output files (default = \"out\".", default="out")
    parser.add_argument("-c", "--chromosome", help="chromosome to tile (required).", required=True)
    args = parser.parse_args()
    return(args)

def parse_fasta(args):
    all_normal_chroms = []
    cur = {"head": "", "seq": ""}
    special = {"head": "", "seq": ""}
    cur_special = False
    seq = ""
    print("reading data:\n\n")
    for i, l in tqdm(enumerate(sys.stdin)):
        l = l.rstrip('\n')
        
        if len(l) == 0:
            continue
        
        if l[0] == ">":
            if not cur_special:
                if len(cur["head"]) > 0:
                    cur["seq"] = seq
                    all_normal_chroms.append(cur)
            else:
                cur["seq"] = seq
                special = cur
            cur = {"head": l[1:], "seq": ""}
            seq = ""
            cur_special = l[1:] == args.chromosome
        else:
            seq += l
        
    if not cur_special:
        if len(cur["head"]) > 0:
            cur["seq"] = seq
            all_normal_chroms.append(cur)
    else:
        cur["seq"] = seq
        special = cur
    return(all_normal_chroms, special)

def chunks(lst, n):
    """Yield successive n-sized chunks from lst."""
    for i in range(0, len(lst), n):
        yield lst[i:i + n]

def get_splitset(seql, width, chrlen):
    breakpoints = [x for x in range(0, chrlen, width)][1:]
    print(breakpoints)
    splits = []
    for chunk in chunks(seql, width):
        splits.append("".join(chunk))
    splitset = {"width": width, "breakpoints": breakpoints, "splits": splits}
    return(splitset)

def make_tiled_chroms(args, special):
    chrlen = len(special["seq"])
    resolution = int(args.resolution)
    if (resolution < 1):
        sys.exit("resolution too small!")
    seql = list(special["seq"])
    widths = []
    width = resolution
    while width < (chrlen):
        widths.append(width)
        width = width * 2
    allsplits = []
    print("making splits:\n\n")
    for width in tqdm(widths):
        seql_temp = [x for x in seql]
        splitset = get_splitset(seql_temp, width, chrlen)
        allsplits.append(splitset)
    return(allsplits)

def print_all(args, fasta, special, tiled_chroms):
    os.makedirs(args.out_dir, exist_ok = True)
    print("printing chroms:\n\n")
    for tiled_chrom in tqdm(tiled_chroms):
        opath = args.out_dir + "/width_" + str(tiled_chrom["width"]) + "_split.fa"
        print_fasta(fasta, special, tiled_chrom, opath,)

def print_fasta(fasta, special, tiled_chrom, opath,):
    with open(opath, "w") as oconn:
        for entry in fasta:
            oconn.write((">" + entry["head"] + "\n"))
            oconn.write((entry["seq"] + "\n"))
        for index, split_chrom in enumerate(tiled_chrom["splits"]):
            oconn.write(">" + special["head"] + "_split" + str(index) + "\n")
            oconn.write(split_chrom + "\n")
        

def tile_fasta(args):
    fasta, special = parse_fasta(args)
    tiled_chroms = make_tiled_chroms(args, special)
    print_all(args, fasta, special, tiled_chroms)

def main():
    args = parse_all_args()
    tile_fasta(args)

if __name__ == "__main__":
    main()

