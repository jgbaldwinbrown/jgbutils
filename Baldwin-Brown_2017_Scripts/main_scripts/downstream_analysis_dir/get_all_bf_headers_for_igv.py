#!/usr/bin/env python

from __future__ import print_function

indices = range(2,72,3)
all_out=[]
for i in indices:
    all_out.append("bf"+str(i))
    all_out.append("bf"+str(i)+"_win25")
    #print("\tbf"+str(i)+"\tbf"+str(i)+"_win25",end="")
print(",".join(map(str,all_out)))

