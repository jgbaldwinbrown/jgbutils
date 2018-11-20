import fileinput
import sys

for line in fileinput.input():
    line = line.rstrip()
    sline = line.split("/")
    outline = "/".join(sline[1:-1])
    sys.stdout.write(outline + "\n")

