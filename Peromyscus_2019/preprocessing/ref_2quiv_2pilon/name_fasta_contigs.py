import fileinput

counter = 1
for line in fileinput.input():
    line = line.rstrip('\n')
    if line [0] == ">":
        index = "%010d" % (counter,)
        header = ">C" + index
        counter += 1
        print header
    else:
        print line

