import fileinput

gensize=2.9e9
bpsum=0
for entry in enumerate(fileinput.input()):
    index = entry[0]
    line = entry[1]
    if index == 0:
        continue
    sline = line.rstrip('\n').split()
    start = int(sline[1])
    end = int(sline[2])
    diff = end - start
    diff2 = diff + 1
    bpsum = bpsum + diff2

print "bpsum=" + str(bpsum)
print "genfrac=" + str(float(bpsum)/float(gensize))
