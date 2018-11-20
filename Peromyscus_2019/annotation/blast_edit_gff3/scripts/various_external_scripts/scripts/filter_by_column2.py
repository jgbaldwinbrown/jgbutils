#!/usr/bin/env python

import sys

args = sys.argv[1:]
if not args[0] == "--header":
    header = False
    if len(args) % 2 != 0:
        sys.exit("must have an even number of arguments")
    cols = map(int,args[0::2])
    terms = args[1::2]
else:
    header = True
    if len(args) % 2 != 1:
        sys.exit("must have an even number of arguments")
    cols = map(int,args[1::2])
    terms = args[2::2]

tests = []
for entry in terms:
    if entry[0:2] == "c=":
        tests.append(lambda x, y=entry[2:]: x == y)
    elif entry[0:2] == ">=":
        tests.append(lambda x, y=float(entry[2:]): float(x) >= y)
    elif entry[0:2] == "<=":
        tests.append(lambda x, y=float(entry[2:]): float(x) <= y)
    elif entry[0:1] == "<":
        tests.append(lambda x, y=float(entry[1:]): float(x) < y)
    elif entry[0:1] == ">":
        tests.append(lambda x, y=float(entry[1:]): float(x) > y)
    elif entry[0:1] == "=":
        tests.append(lambda x, y=float(entry[1:]): float(x) == y)
    else:
        sys.exit("couldn't parse test argument " + str(entry))

for lineentry in enumerate(sys.stdin):
    lineindex = lineentry[0]
    line = lineentry[1]
    if lineindex == 0 and header:
        print line.rstrip('\n') + "\tfilter_value"
        continue
    sline = line.strip().split()
    ok=True
    #print line #debug
    for entry in enumerate(cols):
        index = entry[0]
        col = entry[1]
        #print index #debug
        #print col #debug
        #print sline[col] #debug
        if not tests[index](sline[col]):
            ok = False
        #print ok #debug
    if ok:
        print line.rstrip('\n') + "\tPassed"
    if not ok:
        print line.rstrip('\n') + "\tFailed"
