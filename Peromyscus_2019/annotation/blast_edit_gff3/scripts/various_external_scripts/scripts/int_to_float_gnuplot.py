#!/usr/bin/env python
import fileinput
import re

def is_int(s):
    try:
        int(s)
        return True
    except ValueError:
        return False

def int_to_float(afile):
    if ".gp" in afile:
        int_to_float_gp(afile)
    if ".rplot" in afile or ".fplot" in afile:
        int_to_float_rf(afile)

def int_to_float_gp(afile):
    outfile = open("out2.gp","w")
    for line in open(afile.rstrip('\n'),"r"):
        newline = line.rstrip('\n')
        intswitch=True
        for i in ["size","border","tics scale","format","style line","title"]:
            if i in newline:
                intswitch = False
        if intswitch:
            newline = re.sub(r'(\d+)',r'\1.0',newline)
        if "out.ps" in newline:
            newline = newline.replace("out.ps","out2.ps")
        if "out.rplot" in newline:
            newline = newline.replace("out.rplot","out2.rplot")
        if "out.fplot" in newline:
            newline = newline.replace("out.fplot","out2.fplot")
        outfile.write(newline+"\n")

def int_to_float_rf(afile):
    if ".rplot" in afile:
        outfile = open("out2.rplot","w")
    if ".fplot" in afile:
        outfile = open("out2.fplot","w")
    for line in open(afile.rstrip('\n'),"r"):
        newline = line.rstrip('\n')
        intswitch=True
        for i in ["size","border","tics scale","format","style line","title"]:
            if i in newline:
                intswitch = False
        if intswitch:
            newline = re.sub(r'(\d+)',r'\1.0',newline)
        if "out.ps" in newline:
            newline = newline.replace("out.ps","out2.ps")
        if "out.rplot" in newline:
            newline = newline.replace("out.rplot","out2.rplot")
        if "out.fplot" in newline:
            newline = newline.replace("out.fplot","out2.fplot")
        outfile.write(newline+"\n")


def main():
    for entry in fileinput.input():
        int_to_float(entry)

if __name__ == "__main__":
    main()
