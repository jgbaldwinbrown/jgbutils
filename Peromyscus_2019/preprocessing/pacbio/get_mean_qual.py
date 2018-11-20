import fileinput

tot=0.0
nlines=0

for line in fileinput.input():
  line = float(line.rstrip('\n'))
  tot += line
  nlines += 1

avg = float(tot) / float(nlines)
print avg
