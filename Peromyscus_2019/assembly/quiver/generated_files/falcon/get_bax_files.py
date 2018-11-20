import fileinput
import os
import tarfile

indata = [line.strip() for line in fileinput.input]

import os, fnmatch
def find(pattern, path):
    result = []
    for root, dirs, files in os.walk(path):
        for name in files:
            if fnmatch.fnmatch(name, pattern):
                result.append(os.path.join(root, name))
    return result

def untar(fname):
    if (fname.endswith("tar.gz")):
        tar = tarfile.open(fname)
        tar.extractall()
        tar.close()
        print "Extracted in Current Directory"
    else:
        print "Not a tar.gz file: '%s '" % sys.argv[0]

for entry in indata:
    sentry = entry.split()
    cellname = sentry[0]
    path = sentry[1]
    if not os.path.exists(cellname):
        os.makedirs(cellname)
        os.chdir(cellname)
        untar(path)
        os.rename(
