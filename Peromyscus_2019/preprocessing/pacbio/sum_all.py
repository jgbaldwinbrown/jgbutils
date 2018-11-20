import fileinput

i=0
total = 0
for liner in fileinput.input():
    line = liner.rstrip('\n')
    if i == 1:
        linen = int(line.split()[-1])
        total += linen
    i+=1

print total

cov = float(total) / 2.6e9
print cov
