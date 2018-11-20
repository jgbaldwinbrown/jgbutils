import sys
import fileinput

def mean(l):
  return float(sum(l))/len(l) if len(l) > 0 else float('nan')

i=0
problist = []
for linea in fileinput.input():
  line=linea.rstrip("\n")
  if i % 4 == 3:
    problist=[]
    for j in range(0,len(line)):
      phredscore = ord(line[j]) - 33
      probgood = 1 - (float(10) ** (-float(phredscore)/float(10)))
      problist.append(probgood)
    #print problist
    print mean(problist)
  i += 1

