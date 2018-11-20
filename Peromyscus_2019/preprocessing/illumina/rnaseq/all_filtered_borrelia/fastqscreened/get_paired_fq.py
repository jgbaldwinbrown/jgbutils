import sys
import gzip

args=sys.argv

fq1=args[1]
fq2=args[2]

fqo1=fq1.split(".")[0] + "_repaired.fq.gz"
fqo2=fq2.split(".")[0] + "_repaired.fq.gz"

fq1heads = set([])
fq2heads = set([])

for e in enumerate(gzip.open(fq1,'r')):
    i=e[0]
    l=e[1]
    if i%4==0:
        fq1heads.add(l.split(" ")[0])

for e in enumerate(gzip.open(fq2,'r')):
    i=e[0]
    l=e[1]
    if i%4==0:
        fq2heads.add(l.split(" ")[0])

fqi = fq1heads & fq2heads

with gzip.open(fqo1,"w") as ofile:
    for e in enumerate(gzip.open(fq1,'r')):
        i=e[0]
        l=e[1]
        if i%4==0:
            header=l
        if i%4==1:
            seq=l
        if i%4==2:
            plus=l
        if i%4==3:
            qual=l
            if header.split(" ")[0] in fqi:
                ofile.write(header+seq+plus+qual)

with gzip.open(fqo2,"w") as ofile:
    for e in enumerate(gzip.open(fq2,'r')):
        i=e[0]
        l=e[1]
        if i%4==0:
            header=l
        if i%4==1:
            seq=l
        if i%4==2:
            plus=l
        if i%4==3:
            qual=l
            if header.split(" ")[0] in fqi:
                ofile.write(header+seq+plus+qual)

