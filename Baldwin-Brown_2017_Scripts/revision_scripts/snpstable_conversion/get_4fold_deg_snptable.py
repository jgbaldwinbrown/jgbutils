import sys
from sets import Set

args = sys.argv
snptablepath = args[1]
deg4path = args[2]

deg4s = Set([])
with open(deg4path,"r") as degfile:
    for line in degfile:
        rline = line.rstrip('\n')
        deg4s.add(rline)

starting=True
with open(snptablepath,"r") as snpfile:
    for line in snpfile:
        if starting:
            starting=False
            print line.rstrip('\n')
        else:
            sline = line.rstrip('\n').split()
            key = "\t".join(map(str,[sline[1],int(sline[2])-1,sline[2]]))
            if key in deg4s:
                print line.rstrip('\n')

