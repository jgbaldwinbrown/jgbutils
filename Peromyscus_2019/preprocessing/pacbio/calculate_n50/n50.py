import fileinput

lengths = [int(x) for x in fileinput.input()]

totlength = sum(lengths)

midlength = int(totlength / 2.0)

rnum=0
rlen=0
rcov=0
totseqs = len(lengths)

done = False
while not done:
    rlen = lengths[rnum]
    rcov = rcov + rlen
    rnum = rnum + 1
    #print rnum
    if rnum >= totseqs or rcov >= midlength:
        done = True

print "N50="+str(rlen)+"; L50="+str(rcov)+"; N50 contig count = "+str(rnum)
