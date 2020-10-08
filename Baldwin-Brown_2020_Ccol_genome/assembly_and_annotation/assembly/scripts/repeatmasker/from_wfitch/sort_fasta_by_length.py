import fileinput

data = []

myhead = ""
myseq = ""
for line in fileinput.input():
    line = line.rstrip('\n')
    if line[0] == ">":
        if len(myhead) > 0 and len(myseq) > 0:
            data.append([myhead,myseq])
        myhead = line[1:]
        myseq = ""
    else:
        myseq += line.upper()
if len(myhead) > 0 and len(myseq) > 0:
    data.append([myhead,myseq])

data = sorted(data,key = lambda x: len(x[1]),reverse=True)

iterator = 1
for entry in data:
    print ">C" + str("%010d" % (iterator,))
    print entry[1]
    iterator += 1
