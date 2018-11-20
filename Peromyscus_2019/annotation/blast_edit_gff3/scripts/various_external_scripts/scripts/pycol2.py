#!/usr/bin/env python

import fileinput

data = [x.split() for x in fileinput.input()]

#col_width = max(len(word) for row in data for word in row) + 2  # padding

col_width_unadj = []
for row in data:
    for col in enumerate(row):
        done = False
        while not done:
            try:
                if col_width_unadj[col[0]] < len(col[1]):
                    col_width_unadj[col[0]] = len(col[1])
                done = True
            except IndexError:
                col_width_unadj.append(0)

col_width = [x+2 for x in col_width_unadj]
#print col_width

for row in data:
    outrow = [row[x[0]].ljust(x[1]) for x in enumerate(col_width)]
    print "".join(outrow)
