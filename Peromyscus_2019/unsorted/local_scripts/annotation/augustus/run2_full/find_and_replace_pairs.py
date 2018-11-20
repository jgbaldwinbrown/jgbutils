import sys

pairfile = sys.argv[1]
infile = sys.argv[2]

pdata = open(pairfile,"r").readlines()
data = open(infile,"r").readlines()

for p in pdata:
    p1 = p.split()[0]
    p2 = p.split()[1]
    newdata = []
    for i in data:
        newdata.append(i.replace(p1,p2))
    data = newdata
    del newdata

for i in data:
    print i.rstrip('\n')
