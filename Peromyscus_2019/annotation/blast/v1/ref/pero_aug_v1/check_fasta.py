import fileinput

prevline=""
for e in enumerate(fileinput.input()):
    i=e[0]
    line=e[1]
    if line[0]==">" and len(prevline) > 0:
        if prevline[0]==">":
            print str(i) + "\t" + line.rstrip('\n')
    prevline=line

