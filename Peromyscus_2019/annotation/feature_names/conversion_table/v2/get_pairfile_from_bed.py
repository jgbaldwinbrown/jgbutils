import fileinput

for line in fileinput.input():
    s=line.rstrip('\n').split()
    out=[s[x] for x in [11,15]]
    print "\t".join(out)

