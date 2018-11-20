import fileinput
from fst_calculation_functions import fst_calculation_functions as fstcalc


for entry in enumerate(fileinput.input()):
    index,line = entry
    line = line.rstrip('\n')
    sline = line.split()
    if index == 0:
        mylen = len(sline)
        freqcols = range(5,mylen,2)
        covcols = range(6,mylen,2)
        print line
        continue
    rootvals = sline[0:5]
    fcs = sline[5:]
    freqs = [sline[x] for x in freqcols]
    covs = [sline[x] for x in covcols]
    fcsz = zip(freqs,covs)
    counts = []
    for i in fcsz:
        try:
            f = float(i[0])
            c = float(i[1])
            counts.append(int(round(f*c)))
        except ValueError:
            counts.append("NA")
    outvals = [x for y in zip(counts,covs) for x in y]
    rootvals.extend(outvals)
    print "\t".join(map(str,rootvals))

