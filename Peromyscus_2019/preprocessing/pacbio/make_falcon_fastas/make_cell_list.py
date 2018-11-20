#all_tars_firstline.txt
#all_extras_to_extract.txt

rootnames=[line.rstrip('\n').split("/")[-1].split(".")[0] for line in open("all_tars_firstline.txt","r")]
pathnames=[line.rstrip('\n') for line in open("all_extras_to_extract.txt")]

for i in xrange(len(rootnames)):
    myroot = rootnames[i]
    mypath = pathnames[i]
    print myroot + "\t" + mypath
