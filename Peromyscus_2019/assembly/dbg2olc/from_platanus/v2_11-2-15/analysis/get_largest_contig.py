import fileinput

longest=0

for line in fileinput.input():
    if ">" not in line:
        line=line.rstrip('\n')
        lline = len(line)
        if lline > longest: longest = lline

print lline

