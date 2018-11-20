import fileinput

header = ""
seq = ""
seqs = []

for aline in fileinput.input():
    line = aline.rstrip('\n')
    if line[0] == ">":
        if len(header) > 0 and len(seq) > 0:
            seqs.append([header,seq])
        header = line
        seq = ""
    else:
        seq = seq + line
seqs.append([header,seq])

seqs = sorted(seqs,key=lambda x: len(x[1]),reverse=True)

for entry in seqs:
    print entry[0]
    print entry[1]

