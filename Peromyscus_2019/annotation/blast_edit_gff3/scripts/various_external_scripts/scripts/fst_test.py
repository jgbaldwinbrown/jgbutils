import sys
import itertools
import fst_calculation_functions as fc

args = sys.argv
infile = args[1]
fcols_string = args[2]
ccols_string = args[3]

fcols = map(int,fcols_string.split(","))
ccols = map(int,ccols_string.split(","))

npops = len(fcols)
ncomp = fc.nCr(npops,2)
ncomp2 = ncomp * 2

for entry in enumerate(open(infile,"r")):
    index = entry[0]
    line = entry[1].rstrip('\n')
    sline = line.split()
    if index == 0:
        #headers = ["FST","other"]
        headers = []
        for i in xrange(npops):
            for j in xrange((i+1),npops):
                headers.append("fst_"+str(i)+"_"+str(j))
        headers.append("fst_mean")
        sline.extend(headers)
        print "\t".join(map(str,sline))
        continue
    try:
        fs = [float(sline[x]) for x in fcols]
        cs = [int(sline[x]) for x in ccols]
    except ValueError:
        sline.extend(["NA" for x in xrange(ncomp+1)])
        print "\t".join(map(str,sline))
        continue
    #print fcols
    #print ccols
    hitcounts = [int(round(f*c)) for f,c in itertools.izip(fs,cs)]
    #for i in hitlist:
    #    print "\t".join(map(str,i))
    try:
        fstmat = fc.all_pairwise_tests(hitcounts,cs,fc.FST_W_pairwise)
    except ValueError:
        sline.extend(["NA" for x in xrange(ncomp+1)])
        print "\t".join(map(str,sline))
        continue
    fstmatflat = fc.flatten_sparse(fstmat)
    meanfst = fc.mean(fstmatflat)
    sline.extend(fstmatflat)
    sline.append(meanfst)
    print "\t".join(map(str,sline))
    #print fc.flatten_sparse(fstmat)
    #print fstmat
