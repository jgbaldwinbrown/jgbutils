import fileinput

known = set([])
for line in fileinput.input():
    line = line.rstrip('\n')
    ind = line.split()[0]
    if ind in known:
        continue
    else:
        known.add(ind)
        print line

