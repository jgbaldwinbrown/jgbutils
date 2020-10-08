with open("temp/platanus/fqjoin_180_paths.txt") as file:
  paths_180bp = file.readlines()

with open("temp/platanus/fqjoin_500_paths.txt") as file:
  paths_500bp = file.readlines()

with open("raw_data/louse_from_mike_dir/all_3500_PE_to_use.txt") as file:
  paths_3500bp = file.readlines()

with open("raw_data/louse_from_mike_dir/all_8200_PE_to_use.txt") as file:
  paths_8200bp = file.readlines()

paths_180bp_non = map(lambda x: x.rstrip('\n'),paths_180bp)
paths_500bp_non = map(lambda x: x.rstrip('\n'),paths_500bp)
paths_3500bp_non = map(lambda x: x.rstrip('\n'),paths_3500bp)
paths_8200bp_non = map(lambda x: x.rstrip('\n'),paths_8200bp)
paths_gdna_non = paths_180bp_non + paths_500bp_non

path_180bp_f=[]
path_180bp_r=[]
i=0
for line in paths_180bp_non:
  if i % 2 == 0: path_180bp_f.append(line)
  if i % 2 == 1: path_180bp_r.append(line)
  i+=1

path_500bp_f=[]
path_500bp_r=[]
i=0
for line in paths_500bp_non:
  if i % 2 == 0: path_500bp_f.append(line)
  if i % 2 == 1: path_500bp_r.append(line)
  i+=1

path_3500bp_f=[]
path_3500bp_r=[]
i=0
for line in paths_3500bp_non:
  if i % 2 == 0: path_3500bp_f.append(line)
  if i % 2 == 1: path_3500bp_r.append(line)
  i+=1

path_8200bp_f=[]
path_8200bp_r=[]
i=0
for line in paths_8200bp_non:
  if i % 2 == 0: path_8200bp_f.append(line)
  if i % 2 == 1: path_8200bp_r.append(line)
  i+=1

a180bp_scaf_list=[]
a180bp_gap_list=[]
mindex=1
moindex=1
for i in xrange(len(path_180bp_f)):
  a180bp_scaf_list.append("-IP" + str(mindex))
  a180bp_scaf_list.append(path_180bp_f[i])
  a180bp_scaf_list.append(path_180bp_r[i])
  a180bp_scaf_list.append("-a" + str(mindex))
  a180bp_scaf_list.append("180")
  a180bp_scaf_list.append("-d" + str(mindex))
  a180bp_scaf_list.append("20")
  
  a180bp_gap_list.append("-OP" + str(mindex))
  a180bp_gap_list.append(path_180bp_f[i])
  a180bp_gap_list.append(path_180bp_r[i])
  mindex += 1

a500bp_scaf_list=[]
a500bp_gap_list=[]
for i in xrange(len(path_500bp_f)):
  a500bp_scaf_list.append("-IP" + str(mindex))
  a500bp_scaf_list.append(path_500bp_f[i])
  a500bp_scaf_list.append(path_500bp_r[i])
  a500bp_scaf_list.append("-a" + str(mindex))
  a500bp_scaf_list.append("500")
  a500bp_scaf_list.append("-d" + str(mindex))
  a500bp_scaf_list.append("20")
  
  a500bp_gap_list.append("-OP" + str(mindex))
  a500bp_gap_list.append(path_500bp_f[i])
  a500bp_gap_list.append(path_500bp_r[i])
  mindex += 1

a3500bp_scaf_list=[]
a3500bp_gap_list=[]
for i in xrange(len(path_3500bp_f)):
  a3500bp_scaf_list.append("-OP" + str(mindex))
  a3500bp_scaf_list.append(path_3500bp_f[i])
  a3500bp_scaf_list.append(path_3500bp_r[i])
  a3500bp_scaf_list.append("-a" + str(mindex))
  a3500bp_scaf_list.append("3500")
  a3500bp_scaf_list.append("-d" + str(mindex))
  a3500bp_scaf_list.append("20")
  
  a3500bp_gap_list.append("-OP" + str(mindex))
  a3500bp_gap_list.append(path_3500bp_f[i])
  a3500bp_gap_list.append(path_3500bp_r[i])
  moindex += 1

a8200bp_scaf_list=[]
a8200bp_gap_list=[]
for i in xrange(len(path_8200bp_f)):
  a8200bp_scaf_list.append("-OP" + str(mindex))
  a8200bp_scaf_list.append(path_8200bp_f[i])
  a8200bp_scaf_list.append(path_8200bp_r[i])
  a8200bp_scaf_list.append("-a" + str(mindex))
  a8200bp_scaf_list.append("8200")
  a8200bp_scaf_list.append("-d" + str(mindex))
  a8200bp_scaf_list.append("20")
  
  a8200bp_gap_list.append("-OP" + str(mindex))
  a8200bp_gap_list.append(path_8200bp_f[i])
  a8200bp_gap_list.append(path_8200bp_r[i])
  moindex += 1

all_short_string = " ".join(paths_gdna_non)
all_180bp_scaf_string = " ".join(a180bp_scaf_list)
all_180bp_gap_string = " ".join(a180bp_gap_list)
all_500bp_scaf_string = " ".join(a500bp_scaf_list)
all_500bp_gap_string = " ".join(a500bp_gap_list)
all_3500bp_scaf_string = " ".join(a3500bp_scaf_list)
all_3500bp_gap_string = " ".join(a3500bp_gap_list)
all_8200bp_scaf_string = " ".join(a8200bp_scaf_list)
all_8200bp_gap_string = " ".join(a8200bp_gap_list)
outpath = "/temp/platanus"

print "#!/bin/bash"
print "#$ -N plat_tig"
print "#$ -pe openmp 64"
print "#$ -R Y"
print "#$ -q bio,pub64"
print "#platanus assemble -t 32 -f " + all_short_string + " -o " + outpath +"plat_assembly -m 512 1> " + outpath + "plat_assembly_out.txt 2> " + outpath + "plat_assembly_err.txt"
print ""
print "#platanus scaffold -t 32 -c " + outpath + "plat_assembly_contig.fa -b " + outpath + "plat_assembly_contigBuggle.fa " + all_180bp_scaf_string + all_500bp_scaf_string + all_3500bp_scaf_string + all_8200bp_scaf_string + " 1> " + outpath + "plat_scaffold_out.txt 2> " + outpath + "plat_scaffold_err.txt"
print ""
print "platanus gap_close -t 32 -c " + outpath + "plat_assembly_contig.fa -b " + outpath + "plat_assembly_contigBuggle.fa " + all_180bp_gap_string + all_500bp_gap_string + all_3500bp_gap_string + all_8200bp_gap_string + " 1> " + outpath + "plat_gapclose_out.txt 2> " + outpath + "plat_gapclose_err.txt"
print ""
