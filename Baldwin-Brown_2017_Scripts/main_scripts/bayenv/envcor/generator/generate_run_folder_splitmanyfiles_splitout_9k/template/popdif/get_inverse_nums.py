import sys

infile=sys.argv[1]
numsnps=int(sys.argv[2])

myset = set()
for line in open(infile,"r"):
    num = int(line.rstrip('\n').split()[0].split('s')[-1])
    myset.add(num)

for i in range(1,numsnps):
    if not i in myset:
        print i

