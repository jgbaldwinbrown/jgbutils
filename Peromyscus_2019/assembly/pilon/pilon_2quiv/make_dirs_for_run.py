import subprocess
import fileinput

for line in fileinput.input():
    sline = line.rstrip('\n').split('/')
    for i in xrange(1,len(sline)+1):
        path_to_make = "/".join(sline[0:i])
        print path_to_make
        subprocess.call(['mkdir',path_to_make])
    path_to_make_full = line.rstrip('\n')
    #print path_to_make_full
    #subprocess.call(['mkdir',path_to_make_full])

