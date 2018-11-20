import subprocess
import re

sample_desc_temp = [x.rstrip('\n').split("\t") for x in open("full_sample_description.txt")]
sample_desc = sample_desc_temp[1:]

indir = "feature_counts/"
outdir = "feature_counts_combo/"
infile_list = [x.rstrip('\n') for x in open("all_countfiles.txt","r")]


def combine_file_set(infilelist,outfile):
    infilelist2 = filter(lambda x: len(x) > 0 and "READ2" not in x, infilelist)
    infilelist3 = [x.split('.')[0] for x in infilelist2]
    print infilelist3
    filelist = []
    for i in range(len(infilelist3)):
        regex_string = ".*(" + infilelist3[i] + ").*"
        regex = re.compile(regex_string)
        all_reg_hits = [m.group(0) for l in infile_list for m in [regex.search(l)] if m]
        print all_reg_hits
        filelist.append(all_reg_hits[0])
        print filelist
    if len(filelist) <= 0:
        raise ValueError("Must include at least 1 file for each sample!")
    elif len(filelist) <= 1:
        subprocess.call(["cp", indir + filelist[0], outfile])
    else:
        subprocess.call(["cp", indir + filelist[0], "temp.txt"])
        for i in range(1,len(filelist)):
            subprocess.call(["python","combine_feature_counts.py","temp.txt",indir+filelist[i]],stdout=open("temp2.txt","w"))
            subprocess.call(["mv","temp2.txt","temp.txt"])
        subprocess.call(["mv","temp.txt",outfile])

for l in sample_desc:
    outfile = outdir+l[0].replace("/","_")
    combine_file_set(l[8:],outfile)

