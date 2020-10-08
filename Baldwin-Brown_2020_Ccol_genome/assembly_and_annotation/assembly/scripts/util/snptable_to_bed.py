import fileinput

for e in enumerate(fileinput.input()):
    i=e[0]
    l=e[1].rstrip('\n')
    sl=l.split('\t')
    if i<=0:
        continue
    newstart=str(int(sl[2])-1)
    sl.append(newstart)
    outlist= [str(sl[x]) for x in [1,-1,2,3,4,5,6]]
    print "\t".join(outlist)

#Nmiss   CHROM   POS     REF     ALT     freq_all_out    N_all_out
#0       taxon.5.500.180_contig_1        94      A       G       0.41764706      170
#0       taxon.5.500.180_contig_1        99      C       T       0.68794326      141
#0       taxon.5.500.180_contig_1        7996    G       T       0.69273743      179
