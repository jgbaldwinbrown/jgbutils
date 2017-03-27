import sys
import itertools
from fst_calculation_functions import FST_W_pairwise as fst

args = sys.argv
infile = args[1]
fcols_string = args[2]
ccols_string = args[3]

fcols = map(int,fcols_string.split(","))
ccols = map(int,ccols_string.split(","))

for entry in enumerate(open(infile,"r")):
    index = entry[0]
    line = entry[1].rstrip('\n')
    sline = line.split()
    if index == 0:
        sline.extend(["fst","other"])
        print "\t".join(map(str,sline))
        continue
    try:
        fs = [int(float(sline[x])) for x in fcols]
        cs = [int(float(sline[x])) for x in ccols]
    except ValueError:
        sline.extend(["NA","NA"])
        print "\t".join(map(str,sline))
        continue
    #print fs
    #print cs
    count1 = fs[0]
    count2 = fs[1]
    n1 = cs[0]
    n2 = cs[1]
    #for i in hitlist:
    #    print "\t".join(map(str,i))
    try:
        myfst,other = fst([n1,count1,n2,count2])
    except ValueError,ZeroDivisionError:
        sline.extend(["NA","NA"])
        print "\t".join(map(str,sline))
        continue
    sline.extend([myfst,other])
    print "\t".join(map(str,sline))

