import sys
import random

rseed = int(sys.argv[1])
entries = int(sys.argv[2])

random.seed(rseed)

for i in xrange(entries):
    print random.randrange(0,100000000)

