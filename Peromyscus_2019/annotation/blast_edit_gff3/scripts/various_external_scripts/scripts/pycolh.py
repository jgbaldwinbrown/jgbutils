#!/usr/bin/env python

import fileinput

data = [x.split() for x in fileinput.input()]

ncols = len(data[0])

data.insert(0,map(str,xrange(ncols)))

col_width = max(len(word) for row in data for word in row) + 2  # padding
for row in data:
    print "".join(word.ljust(col_width) for word in row)
