import fileinput

for line in fileinput.input():
    sline = line.rstrip('\n').split()
    print "\t".join(sline[:-2])

