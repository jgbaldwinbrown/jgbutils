#!/usr/bin/env python3

import sys
import re
import gzip
import io

def getconn(path):
    regex = re.compile(r'^.*\.gz$')
    if regex.match(path):
        conn = io.TextIOWrapper(io.BufferedReader(gzip.open(path)), encoding='utf8', errors='ignore')
    else:
        conn = open(path,"r")
    return(conn)

def printfa(conn, name):
    for l in conn:
        l=l.rstrip('\n')
        if l[0] == ">":
            l = ">" + name + " " + l[1:]
        print(l)

for l in sys.stdin:
    l=l.rstrip('\n')
    name = l
    conn = getconn(l)
    printfa(conn, name)

#io.TextIOWrapper(io.BufferedReader(gzip.open(filePath)), encoding='utf8', errors='ignore') 

