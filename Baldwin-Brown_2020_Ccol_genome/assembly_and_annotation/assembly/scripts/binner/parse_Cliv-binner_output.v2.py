########################################################################################################################
__author__  = 'Steven Flygare; modified by Aurelie Kapusta'
__date__    = "Mar 2016"
__version__ = "2.0"
########################################################################################################################
import sys
import argparse
from Bio import SeqIO
from collections import defaultdict

#Arguments
parser = argparse.ArgumentParser(description="Binner parsing script, for Taxonomer at least of Feb 2016")
parser.add_argument("-i", "--input", help="binner output", action="store", required=True)
parser.add_argument("-o", "--output", help="name of the output file, default = input_file_cutoff.parsed", action="store", required=False)
parser.add_argument("-c", "--cutoff", type=float, help="bin cutoff, e.g. 0.5 will assign sequences to a bin if 50% of the kmers are assigned to that bin", action="store", required=True)
parser.add_argument("-e", "--extract", help="to extract sequences binned to a list of bin IDs (comma separated) from the output file: this means extract joined reads if reads were joined before binning. Use -r to provide the paired reads if you'd like to extract non joined reads", action="store", required=False)
parser.add_argument("-r", "--reads", help="taxonomer input file(s), comma separated (fastq, fasta). Required if --E. Will also be used with -e if provided", action="store", required=False)
parser.add_argument("-E", "--Extract", help="Also requies Taxonomer input file; to extract sequences NOT binned to a list of bins IDs (comma separated if more than one)", action="store", required=False)
parser.add_argument("-p", "--printbins", help="to print the binner categories (key of IDs and refseq category); will print and exit but still needs required args", action="store_true", required=False)

args = parser.parse_args()
input_file = args.input
output_file = args.output
bin_cutoff = args.cutoff
extract = args.extract
Extract = args.Extract
reads = args.reads
ifprint = args.printbins

#Bins:, could be loaded but hard coded is fine for now.
#bins = {0: "unbinned", 1: "vertebrate_mammalian", 2: "vertebrate_other", 4: "invertebrate", 8: "fungi", 16: "protozoa", 32: "plant", 64: "bacteria", 128: "archaea", 256: "plasmid", 512: "viral", 1024: "plastid"}
bins = {0: "unbinned", 1: "Hs_louse", 2: "pigeon", 4: "human"}

####################################################
# FUNCTIONS
####################################################
#Extract the counts
def percent_bin(binner_data):
    bin_counts = {}
    for tbd in binner_data.split(";"):
        bin_data = tbd.split("-")
        if len(bin_data) > 1:
            bin_counts[int(bin_data[0])] = int(bin_data[1])
    total_count = 0
    max_count = 0
    max_bin = 0
    for bin_v,count in bin_counts.iteritems():
        if bin_v == 0:
            continue
        total_count += count
        if count > max_count:
            max_count = count
            max_bin = bin_v
    
    if total_count == 0:
        total_count += 1
    return max_bin, float(max_count)/float(total_count)

####################################################
# PREP STUFF
####################################################
if ifprint:
    sys.stderr.write("#Binner categories index is as follow:\n")
    for k in sorted(bins):
        sys.stderr.write("%s\t%s\n"%(k,bins[k]))
    sys.exit()

#Get output file name
if not output_file:
    output_file = input_file + "_" + str(bin_cutoff) + ".parsed"
summary_file = output_file + ".summary"
parsed_out = open(output_file, 'w')
summary_out = open(summary_file, 'w')

#Extracted reads outputs
if extract and not reads:
    reads_out = input_file + "_" + str(bin_cutoff) + ".extract.fa"
    reads_fa = open(reads_out, 'w')

#sys.stderr.write("log" stuff
sys.stderr.write("#input file = %s\n" % input_file)
sys.stderr.write("#cutoff = %f\n" % bin_cutoff)

#Get the bin_ids for -e or -E, and read files if -r
if extract:
    sys.stderr.write("#Extract reads when binned as: %s\n" % extract)
    bin_ids = extract.split(",")

if Extract:
    sys.stderr.write("#Extract reads from taxonomer input file(s) when NOT binned as: %s\n" % Extract)
    if not reads:
        sys.stderr.write("ERROR: please provide taxonomer input file(s) with -r\n")
        sys.exit()
    bin_ids = Extract.split(",")

reads_dict = dict()
if reads:
    if extract: sys.stderr.write("#Original read files will be used to extract sequences, and not the binner output\n")
    read_files = reads.split(",")
    #need to load the file(s)
    for file in read_files:
        #check if fastq or fasta
        with open(file, 'r') as f:
            l = f.readline()
            if l[:1] is ">": format = 'fasta'
            if l[:1] is "@": format = 'fastq'
        sys.stderr.write("#format of file " + file + " = " + format + "\n")
        sys.stderr.write("# => loading dictionary...\n")
        reads_dict[file] = SeqIO.index(file, format)
        sys.stderr.write("#    %s sequences indexed\n"%len(reads_dict[file]))
        #also prep output(s)
        reads_out = input_file + "_" + str(bin_cutoff) + "." + file
        reads_fa = open(reads_out, 'w')


####################################################
# MAIN STUFF
####################################################
#Loop through the binner output; get numbers but also length
sys.stderr.write("#Looping through binner output and printing parsed output = %s\n"% output_file)
if extract: sys.stderr.write("#(and extracting sequences of reads)\n")
if Extract: sys.stderr.write("#(and extracting sequences of some reads)\n")
to_extract = list()
binned = list()
summary = dict()
for line in open(input_file,'r'):
    data = line.strip().split('\t')
    if len(data) < 2:
        continue
    bin_v,percent = percent_bin(data[1])
    binned.append(data[0]) #remember binned reads to extract the complement
    if percent > bin_cutoff:
        slen = len(str(data[2]))
        parsed_out.write("%s\t%d\t%s\t%f\t%d\n"%(data[0],bin_v,bins[bin_v],percent,slen))
        if not bin_v in summary:
            summary[bin_v] = dict()
            summary[bin_v]['counts']=0
            summary[bin_v]['length']=0
        summary[bin_v]['counts']+=1
        summary[bin_v]['length']+=slen
        if extract and not reads:
            if str(bin_v) in bin_ids:
                reads_fa.write(">" + data[0] + "\n" + data[2] + "\n")
        if reads:
            if (extract and str(bin_v) in bin_ids) or (Extract and str(bin_v) not in bin_ids):
                for f in reads_dict:
                    reads_out = input_file + "_" + str(bin_cutoff) + "." + f
                    if data[0] in reads_dict[f]:
                        raw = reads_dict[f].get_raw(str(data[0]))
                        with open(reads_out,'a') as reads_fa: reads_fa.write(raw)
                    else:
                        sys.stderr.write("# -- WARN: %s not in read file %s\n" % (data[0],f))
    else:
        if Extract: to_extract.append(data[0]) #extracting complement means also the ones that are binned but < threshold
parsed_out.close()

#Print summary of the parsed file in a summary file
sys.stderr.write("#Printing summary file = %s\n"%summary_file)
summary_out.write("#Summary for the parsing of %s = %s:\n"%(input_file,output_file))
if reads:
    summary_out.write("#Sequences extracted from read file(s), and number of sequences are:\n")
    for file in read_files:
        total = len(reads_dict[file])
        summary_out.write("#%s\t%s\n"%(file,total))
    summary_out.write("\n#bin_id\tbin_description\tnumber_of_sequences_binned\tpercentage_of_sequences_binned\tpercentage_of_total_sequences\tlength_of_sequences_binned\n")
else:
    summary_out.write("\n#bin_id\tbin_description\tnumber_of_sequences_binned\tpercentage_of_sequences_binned\tlength_of_sequences_binned\n")

for bin_v in sorted(summary):
    bin_perc = float(summary[bin_v]['counts']) / float(len(binned)) * 100
    if reads:
        tot_perc = float(summary[bin_v]['counts']) / float(total) * 100 #it's assuming same number, but easy to correct if not for some reason
        summary_out.write("%d\t%s\t%d\t%f\t%f\t%d\n"%(bin_v,bins[bin_v],summary[bin_v]['counts'],bin_perc,tot_perc,summary[bin_v]['length']))
    else:
        summary_out.write("%d\t%s\t%d\t%f\t%d\n"%(bin_v,bins[bin_v],summary[bin_v]['counts'],bin_perc,summary[bin_v]['length']))
summary_out.write("\n\n")
summary_out.close()

#For -E, also need to get all the reads that are (i) binned but did not get > the cutoff and (ii) not binned
if Extract:
    #(i) binned but < cutoff
    for f in reads_dict:
        sys.stderr.write("#Getting binned reads from %s < cutoff %d\n" %(f,bin_cutoff))
        reads_out = input_file + "_" + str(bin_cutoff) + "." + f
        for read in to_extract:
            if read in reads_dict[f]:
                raw = reads_dict[f].get_raw(str(read))
                with open(reads_out,'a') as reads_fa: reads_fa.write(raw)
            else:
                sys.stderr.write("# -- WARN: %s not in read file %s\n" % (read,f))
    #(ii) not binned, file by file:
    for f in reads_dict:
        sys.stderr.write("#Getting non binned reads from %s\n" % f)
        reads_out = input_file + "_" + str(bin_cutoff) + "." + f
        for read in reads_dict[f]:
            #sys.stderr.write(read.strip())
            if read not in binned:
                #sys.stderr.write(" => not_binned\n")
                raw = reads_dict[f].get_raw(read)
                with open(reads_out,'a') as reads_fa: reads_fa.write(raw)
            #else:
                #sys.stderr.write(" => bin\n")
    reads_fa.close()

#close the indexes
if reads:
    for f in reads_dict:
        reads_dict[f].close()

sys.exit()


