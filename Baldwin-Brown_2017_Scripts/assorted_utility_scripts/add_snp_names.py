#!/usr/bin/env python

import fileinput

for entry in enumerate(fileinput.input()):
    if entry[0] == 0:
        print entry[1].rstrip('\n') + "\tsnpname"
    else:
        print entry[1].rstrip('\n') + "\tsnp" + str("%09d" % (entry[0],))

