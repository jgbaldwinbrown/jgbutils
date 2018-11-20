import sys

pairfile = sys.argv[1]
infile = sys.argv[2]

pdata = open(pairfile,"r").readlines()
data = open(infile,"r")

mypairs = dict()
for p in pdata:
    p1 = p.split()[0]
    p2 = p.split()[1]
    mypairs[p1] = p2

for i in data:
    p1 = i.split()[1].strip('"')
    if p1 in mypairs:
        p2 = mypairs[p1]
        out = i.replace(p1,p2)
    else:
        out = i
    print out.rstrip('\n')
