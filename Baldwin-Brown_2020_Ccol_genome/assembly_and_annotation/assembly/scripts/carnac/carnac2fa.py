import sys

carpath = sys.argv[1]
fapath = sys.argv[2]

fareads = []
header = ""
seq = ""

for l in open(fapath, "r"):
    l=l.rstrip('\n')
    if l[0] == ">":
        if len(header) > 0 and len(seq) > 0:
            fareads.append([header,seq])
        header = l
        seq = ""
    else:
        seq = seq + l
if len(header) > 0 and len(seq) > 0:
    fareads.append([header,seq])

for e in enumerate(open(carpath, "r")):
    i, l = e[0], e[1]
    cluster = "Cluster " + str(i) + ": "
    hits = [int(x) for x in l.rstrip('\n').split()]
    for h in hits:
        oldhead = fareads[h][0]
        seq = fareads[h][1]
        newhead = oldhead[0] + cluster + oldhead[1:]
        print newhead
        print seq
