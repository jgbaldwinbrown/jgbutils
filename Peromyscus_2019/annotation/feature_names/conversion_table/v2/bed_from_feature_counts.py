import fileinput

for e in enumerate(fileinput.input()):
    i=e[0]
    l=e[1].rstrip('\n')
    s=l.split()
    if i > 0:
        out=[s[x].split(";")[0] for x in [1,2,3,0]]
        print "\t".join(out)

