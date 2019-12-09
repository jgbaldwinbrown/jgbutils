import fileinput
import math

started = False

for line in fileinput.input():
    if started:
        count1 = []
        count2 = []
        sline = line.rstrip('\n').split()
        indata = sline[5:]
        i = 0
        for entry in indata:
            if i % 2 == 0:
                freq = float(entry) if not entry == "NA" else "NA"
            if i % 2 == 1:
                totcount = int(entry)
                if freq == "NA":
                    count1.append(0)
                    count2.append(0)
                else:
                    counta = int(math.floor(freq * totcount))
                    countb = totcount - counta
                    count1.append(counta)
                    count2.append(countb)
            i += 1
        out = []
        for p, q in zip(count1, count2):
            out.append(p)
            out.append(q)
        print("\t".join(map(str, out)))
    started = True

