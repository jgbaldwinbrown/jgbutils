import fileinput

i=0
for line in fileinput.input():
    if i % 4 == 1: print line.rstrip('\n')
    i += 1

