with open("paths/gdna_matepair_2k_paths.txt") as file:
  paths_2k_mate = file.readlines()

with open("paths/gdna_matepair_5k_paths.txt") as file:
  paths_5k_mate = file.readlines()

with open("paths/gdna_paths.txt") as file:
  paths_gdna = file.readlines()

paths_gdna_non = map(lambda x: x.rstrip('\n'),paths_gdna)
paths_2k_mate_non = map(lambda x: x.rstrip('\n'),paths_2k_mate)
paths_5k_mate_non = map(lambda x: x.rstrip('\n'),paths_5k_mate)

path_2k_mate_f=[]
path_2k_mate_r=[]
i=0
for line in paths_2k_mate_non:
  if i % 2 == 0: path_2k_mate_f.append(line)
  if i % 2 == 1: path_2k_mate_r.append(line)
  i+=1

path_5k_mate_f=[]
path_5k_mate_r=[]
i=0
for line in paths_5k_mate_non:
  if i % 2 == 0: path_5k_mate_f.append(line)
  if i % 2 == 1: path_5k_mate_r.append(line)
  i+=1

a2k_scaf_list=[]
a2k_gap_list=[]
mindex=1
for i in xrange(len(path_2k_mate_f)):
  a2k_scaf_list.append("-OP" + str(mindex))
  a2k_scaf_list.append(path_2k_mate_f[i])
  a2k_scaf_list.append(path_2k_mate_r[i])
  a2k_scaf_list.append("-a" + str(mindex))
  a2k_scaf_list.append("2000")
  a2k_scaf_list.append("-d" + str(mindex))
  a2k_scaf_list.append("20")
  
  a2k_gap_list.append("-OP" + str(mindex))
  a2k_gap_list.append(path_2k_mate_f[i])
  a2k_gap_list.append(path_2k_mate_r[i])
  mindex += 1

a5k_scaf_list = []
a5k_gap_list = []
for i in xrange(len(path_5k_mate_f)):
  a5k_scaf_list.append("-OP" + str(mindex))
  a5k_scaf_list.append(path_5k_mate_f[i])
  a5k_scaf_list.append(path_5k_mate_r[i])
  a5k_scaf_list.append("-a" + str(mindex))
  a5k_scaf_list.append("5000")
  a5k_scaf_list.append("-d" + str(mindex))
  a5k_scaf_list.append("20")
  
  a5k_gap_list.append("-OP" + str(mindex))
  a5k_gap_list.append(path_5k_mate_f[i])
  a5k_gap_list.append(path_5k_mate_r[i])
  mindex += 1

all_short_string = " ".join(paths_gdna_non)
all_2k_scaf_string = " ".join(a2k_scaf_list)
all_5k_scaf_string = " ".join(a5k_scaf_list)
all_2k_gap_string = " ".join(a2k_gap_list)
all_5k_gap_string = " ".join(a5k_gap_list)
outpath = "/bio/jbaldwi1/tiger_shrimp_data/data/platanus_out/"

print "#!/bin/bash"
print "#$ -N plat_tig"
print "#$ -pe openmp 64"
print "#$ -R Y"
print "#$ -q bio,pub64"
print "cd $SGE_O_WORKDIR"
print "PATH=$PATH:/bio/jbaldwi1/programs/platanus_1.2.1/v2"
print "platanus assemble -t $CORES -f " + all_short_string + " -o " + outpath +"plat_assembly -m 512 1> " + outpath + "plat_assembly_out.txt 2> " + outpath + "plat_assembly_err.txt"
print ""
print "platanus scaffold -t $CORES -c " + outpath + "plat_assembly_contig.fa -b " + outpath + "plat_assembly_contigBuggle.fa " + all_2k_scaf_string + all_5k_scaf_string + " 1> " + outpath + "plat_scaffold_out.txt 2> " + outpath + "plat_scaffold_err.txt"
print ""
print "platanus gap_close -t $CORES -c " + outpath + "plat_assembly_contig.fa -b " + outpath + "plat_assembly_contigBuggle.fa " + all_2k_gap_string + all_5k_gap_string + " 1> " + outpath + "plat_gapclose_out.txt 2> " + outpath + "plat_gapclose_err.txt"
print ""
