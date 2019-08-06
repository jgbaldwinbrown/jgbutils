#!/usr/bin/env python3

import vcf
import numpy as np
import statsmodels.api as sm
import sys
import argparse
import copy

def parse_my_args():
    parser = argparse.ArgumentParser("Compute the Cochran-Mantel-Haenszel test on a VCF file")
    parser.add_argument("vcf", nargs="?", help="Input VCF file; default stdin")
    parser.add_argument("-c", "--control",  help="comma separated, 0-indexed VCF columns to use as controls; required.", required=True)
    parser.add_argument("-t", "--test",  help="comma separated, 0-indexed VCF columns to use as test data; required.", required=True)
    parser.add_argument("-N", "--control_name",  help="Name to assign to control samples. Default=\"Blood\".", required=True)
    parser.add_argument("-n", "--test_name",  help="Name to assign to test samples. Default=\"Sperm\".", required=True)

    args = parser.parse_args()
    return(args)

def get_arg_vars(args):
    if args.vcf:
        inconn = open(args.vcf, "r")
    else:
        inconn = sys.stdin

    control = [int(x) for x in args.control.split(",")]
    test = [int(x) for x in args.test.split(",")]
    control_name = "Blood"
    test_name = "Sperm"
    if args.control_name:
        control_name = args.control_name
    if args.test_name:
        test_name = args.test_name
    return((inconn, control, test, control_name, test_name))

def read_vcf(vcfin, control, test, control_name, test_name):
    vcf_data = []
    for i, record in enumerate(vcfin):
        if i == 0:
            for j in record.num_called:
                vcf_data.append([])
        
        unif_info = [record.CHROM, record.POS, record.ID, ]
        
        #a[0].samples[1].data.AD
        calls = [call for call in record]
        for i in range(len(control)):
            tester[i,0,0] = calls[control[i]].data.AD[0]
            tester[i,0,1] = calls[control[i]].data.AD[1]
            tester[i,1,0] = calls[test[i]].data.AD[0]
            tester[i,1,1] = calls[test[i]].data.AD[1]
        cmh = sm.stats.StratifiedTable(tester)
        writeout(cmh, record, outwriter)

def write_vcf2table(vcf_data):
    for i in vcfdata:
        print("\t".join(map(str, i)))

def main():
    args = parse_my_args()

    inconn, control, test, control_name, test_name = get_arg_vars(args)

    vcfin = vcf.Reader(inconn)
    vcf_data = read_vcf(vcfin, control, test, outwriter)
    write_vcftable(vcf_data)

    inconn.close()

if __name__ == "__main__":
    main()



#>>> for i in b:
#...     for j in i:
#...         try:print(j.data.AD)


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

###fileformat=VCFv4.0
###fileDate=20090805
###source=myImputationProgramV3.1
###reference=1000GenomesPilot-NCBI36
###phasing=partial
###INFO=<ID=NS,Number=1,Type=Integer,Description="Number of Samples With Data">
###INFO=<ID=AN,Number=1,Type=Integer,Description="Total number of alleles in called genotypes">
###INFO=<ID=AC,Number=.,Type=Integer,Description="Allele count in genotypes, for each ALT allele, in the same order as listed">
###INFO=<ID=DP,Number=1,Type=Integer,Description="Total Depth">
###INFO=<ID=AF,Number=.,Type=Float,Description="Allele Frequency">
###INFO=<ID=AA,Number=1,Type=String,Description="Ancestral Allele">
###INFO=<ID=DB,Number=0,Type=Flag,Description="dbSNP membership, build 129">
###INFO=<ID=H2,Number=0,Type=Flag,Description="HapMap2 membership">
###FILTER=<ID=q10,Description="Quality below 10">
###FILTER=<ID=s50,Description="Less than 50% of samples have data">
###FORMAT=<ID=GT,Number=1,Type=String,Description="Genotype">
###FORMAT=<ID=GQ,Number=1,Type=Integer,Description="Genotype Quality">
###FORMAT=<ID=DP,Number=1,Type=Integer,Description="Read Depth">
###FORMAT=<ID=HQ,Number=2,Type=Integer,Description="Haplotype Quality">
###ALT=<ID=DEL:ME:ALU,Description="Deletion of ALU element">
###ALT=<ID=CNV,Description="Copy number variable region">
##CHROM	POS	ID	REF	ALT	QUAL	FILTER	INFO	FORMAT	NA00001	NA00002	NA00003	NA00004
#X	101	rsTest	A	C	10	PASS	.	GT:AD	0:100,5	0/1:50,45	0|1:10,108	0|1:55,45
#X	101	rsTest	A	C	10	PASS	.	GT:AD	0:108,5	0/1:50,45	0|1:10,108	0|1:55,45
#X	101	rsTest	A	C	10	PASS	.	GT:AD	0:80,5	0/1:50,45	0|1:10,108	0|1:55,45
