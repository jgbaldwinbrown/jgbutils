import fileinput

for e in enumerate(fileinput.input()):
    i=e[0]
    l=e[1].rstrip('\n')
    s=l.split()
    if i==0:
        print "Chromosome\tStart\tEnd\tFeature\t" + "\t".join(map(str,s[3:]))
        continue
    chrom=s[0]
    pos=int(float(s[1]))
    name=s[2]
    other=s[3:]
    posm=pos-1
    outl=[chrom,posm,pos,name]
    outl.extend(other)
    print "\t".join(map(str,outl))
