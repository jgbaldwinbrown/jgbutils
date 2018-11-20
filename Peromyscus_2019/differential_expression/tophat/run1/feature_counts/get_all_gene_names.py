import fileinput

names = set([])

for line in fileinput.input():
    if line[0] != "#":
        sline = line.split()
        gname = sline[-1][1:-2]
        names.add(gname)

all_names = sorted(list(names))
for entry in all_names:
    print entry

