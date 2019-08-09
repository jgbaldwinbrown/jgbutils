#!/usr/bin/env python3

import tempfile
import vcf
import numpy as np
import statsmodels.api as sm
import sys
import argparse
import copy

def parse_my_args():
    parser = argparse.ArgumentParser("Compute the Cochran-Mantel-Haenszel test on a VCF file")
    parser.add_argument("vcf", nargs="?", help="Input VCF file; default stdin")
    parser.add_argument("-t", "--tissue", help="Name of a tab-separated file specifying the sample ID in column 1 and the tissue type in column 2", required=True)
    parser.add_argument("-g", "--gc",  help="Per-chromosome tab-separated GC bias table. First column chromosome name, second fraction GC.", required=True)

    args = parser.parse_args()
    return(args)

def get_arg_vars(args):
    if args.vcf:
        inconn = open(args.vcf, "r")
    else:
        inconn = sys.stdin
    
    tissues = {}
    for l in open(args.tissue, "r"):
        sl = l.rstrip('\n').split('\t')
        sample, tissue = (sl[0], sl[1])
        tissues[sample] = tissue
    
    gc = {}
    for l in open(args.gc, "r"):
        sl = l.rstrip('\n').split('\t')
        name, value = (sl[0], float(sl[1]))
        gc[name] = value
    return((inconn, tissues, gc))

def read_vcf(vcfin, tissues, gc):
    tempfiles = []
    for i, record in enumerate(vcfin):
        if i == 0:
            for j in range(len(record.samples)):
            #for j in range(record.num_called):
                tempfiles.append(tempfile.TemporaryFile(mode='w+'))
        
        try:
            gc_frac = gc[record.CHROM]
        except KeyError:
            gc_frac = 'NA'
        unif_info = [record.CHROM, record.POS, gc_frac, record.REF, record.ALT[0]]
        
        for j, call in enumerate(record.samples):
            call_info = unif_info.copy()
            try:
                call_info.append(tissues[call.sample])
            except KeyError:
                call_info.append("NA")
            call_info.append(call.sample)
            call_info.append(call.data.GT)
            if call.data.AD is None:
                call_info.extend([0, 0, 0])
            else:
                call_info.append(int(call.data.AD[0]))
                call_info.append(int(call.data.AD[1]))
                call_info.append(int(call.data.AD[0]) + int(call.data.AD[1]))
            tempfiles[j].write("\t".join(map(str,call_info)) + "\n")
    for indiv in tempfiles:
        indiv.seek(0)
    return(tempfiles)

def write_vcf2table(tempfiles):
    for indiv in tempfiles:
        for position in indiv:
            print(position.rstrip('\n'))
        indiv.close()

def main():
    args = parse_my_args()

    inconn, tissues, gc = get_arg_vars(args)

    vcfin = vcf.Reader(inconn)
    tempfiles = read_vcf(vcfin, tissues, gc)
    write_vcf2table(tempfiles)

    inconn.close()

if __name__ == "__main__":
    main()

#"pos" "indiv" "value" "tissue" "chrom" "gc" "sample" "bias" "count" "hits"
#"1" 1 1 1.26295428488079 "sperm" "1" 0.444345820403328 1 0.549235502170337 2 2
#"2" 2 1 -0.326233360705649 "sperm" "1" 0.444345820403328 1 0.549235502170337 2 2
#"3" 3 1 1.3297992629225 "sperm" "1" 0.444345820403328 1 0.549235502170337 4 1
#"4" 4 1 1.2724293214294 "sperm" "1" 0.444345820403328 1 0.549235502170337 1 0
#"5" 5 1 0.414641434456408 "sperm" "1" 0.444345820403328 1 0.549235502170337 5 4
#"6" 6 1 -1.53995004190371 "sperm" "1" 0.444345820403328 1 0.549235502170337 6 3
#"7" 7 1 -0.928567034713538 "sperm" "1" 0.444345820403328 1 0.549235502170337 3 1
#"8" 8 1 -0.29472044679056 "sperm" "1" 0.444345820403328 1 0.549235502170337 2 1
#"9" 9 1 -0.00576717274753696 "sperm" "1" 0.444345820403328 1 0.549235502170337 3 2

##CHROM	POS	ID	REF	ALT	QUAL	FILTER	INFO	FORMAT	NA00001	NA00002	NA00003	NA00004
#X	101	rsTest	A	C	10	PASS	.	GT:AD	0:100,5	0/1:50,45	0|1:10,108	0|1:55,45
#X	101	rsTest	A	C	10	PASS	.	GT:AD	0:108,5	0/1:50,45	0|1:10,108	0|1:55,45
#X	101	rsTest	A	C	10	PASS	.	GT:AD	0:80,5	0/1:50,45	0|1:10,108	0|1:55,45
